
define nginx::vhost(
	$host = $name,
	$port = '80',
	$root    = "/var/www/$host",
	$server_name = "$host",
) {
	include nginx

	file { "$root":
		ensure => directory,
		owner  => 'www-data',
		group  => 'www-data',
		mode   => '0755',
	}

	file { "content-$root":
		ensure  => present,
		path    => "$root/index.html",
		owner   => 'www-data',
		group   => 'www-data',
		mode    =>  '0644',
		content => "<h1> This is the vhost $host</h1>",
	}
	# Solve path to nginx 
	exec { 'create sites':,
		path    => ['/usr/bin','/bin'],
		unless  => "/usr/bin/test -d  ${nginx::installdir}/conf/sites-available && /usr/bin/test -d ${nginx::installdir}/conf/sites-enabled",
		command => "/bin/mkdir  ${nginx::installdir}/conf/sites-available && /bin/mkdir ${nginx::installdir}/conf/sites-enabled",
		require => Class['nginx']
	}

	file { "$host":
		ensure  => present,
		path    => "$nginx::installdir/conf/sites-available/$host",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template('nginx/vhost.erb'),
		require => Exec['create sites'],
	}
	
	file { "$nginx::installdir/conf/sites-enabled/$host":
		ensure  => link,
		target  => "$nginx::installdir/conf/sites-available/$host",
		require => File["$host"],
	}

	exec {'nginx':
		command => '/etc/init.d/nginx restart',
		require => File["$nginx::installdir/conf/sites-enabled/$host"]
	}
	
}
