
define nginx::vhost(
	$host = $title,
	$port = '80',
	$root    = "/var/www/$host",
	$server_name = "_",
	$nginx = '/opt/nginx',
	$logdir = '/var/log/nginx',
) {
	
	file { "$root":
		ensure => directory,
		owner  => 'www-data',
		group  => 'www-data',
		mode   => '0755',
	}

	file { 'sample':
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
		unless  => "/usr/bin/test -d  $nginx/conf/sites-available && /usr/bin/test -d $nginx/conf/sites-enabled",
		command => "/bin/mkdir  $nginx/conf/sites-available && /bin/mkdir $nginx/conf/sites-enabled",
	}

	file { "$host":
		ensure  => present,
		path    => "$nginx/conf/sites-available/$host",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template('nginx/vhost.erb'),
		require => Exec['create sites'],
	}
	
	file { "$nginx/conf/sites-enabled/$host":
		ensure  => link,
		target  => "$nginx/conf/sites-available/$host",
		require => File["$host"],
	}
	#exec { 'restart nginx'

	exec {'nginx':
		command => '/etc/init.d/nginx restart',
	}
		
	
	
}


