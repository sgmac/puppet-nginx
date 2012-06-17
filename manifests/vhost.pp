
define nginx::vhost(
	$host = $name,
	$port = '80',
	$root    = "/var/www/$host",
	$create_root = true,
	$server_name = "$host",
	$rails = false,
) {

	include nginx

	
	if $create_root{
	file { "$root":
		ensure  => directory,
		owner   => 'www-data',
		group   => 'www-data',
		mode    => '0755',
		require => Class['nginx'],
	}
	}

	$template =  $rails ? {
	        true    => 'vhost.rails.erb',
	        default => 'vhost.erb',
	}

	#	exec { "create sites $host":,
	#		path    => ['/usr/bin','/bin'],
	#		unless  => "/usr/bin/test -d  ${nginx::installdir}/conf/sites-available && /usr/bin/test -d ${nginx::installdir}/conf/sites-enabled",
	#		command => "/bin/mkdir  ${nginx::installdir}/conf/sites-available && /bin/mkdir ${nginx::installdir}/conf/sites-enabled",
	#		require => Class['nginx']
	#	}

	file { "$host":
		ensure  => present,
		path    => "${nginx::installdir}/conf/sites-available/$host",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template("nginx/$template"),
		require => Class['nginx'],
	}

	file { "${nginx::installdir}/conf/sites-enabled/$host":
		ensure  => link,
		target  => "${nginx::installdir}/conf/sites-available/$host",
		require => File["$host"],
	}

	exec {"nginx $host":
		command => '/etc/init.d/nginx restart',
		require => File["${nginx::installdir}/conf/sites-enabled/$host"],
	}
	
}
