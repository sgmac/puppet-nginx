
class nginx (

	$ruby_version = 'ruby-1.9.3-p125',
	$passenger_version = '3.0.12',
	$logdir = '/var/log/nginx',
	$installdir = '/opt/nginx',	
	) {	

	$options = "--auto --auto-download  --prefix=$installdir" 

	include rvm
	rvm_system_ruby {  
		"$ruby_version":
			ensure      => 'present',
			default_use => true;
	}
	rvm_gem {
		"$ruby_version/passenger":
	 		ensure => "$passenger_version",
	}
	
	exec { 'nginx-install':
		command => "/bin/bash -l -i -c \"/usr/local/rvm/gems/$ruby_version/bin/passenger-install-nginx-module $options\"",
		group   => 'root',
		unless  => "/usr/bin/test -d $installdir",
		require => [ Rvm_system_ruby["$ruby_version"], Rvm_gem["$ruby_version/passenger"]];
	}

	file { 'nginx-config':
		path    => "$installdir/conf/nginx.conf",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template('nginx/nginx.conf.erb'),
		require => Exec['nginx-install'],
	}

	file { 'nginx-init':
		path    => '/etc/init.d/nginx',
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		content => template('nginx/nginx.erb'),
		require => File['nginx-config']
	}

	file { "$logdir":
		ensure => directory,
		owner  => 'root',
		group  => 'root',
		mode   => '0644'
	}

	service { 'nginx':
		ensure     => 'running',
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
		subscribe  => File['nginx-config'],
		require    => [ File["$logdir"], File['nginx-init']],
	}

}

