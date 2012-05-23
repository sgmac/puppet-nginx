
define nginx::vhost(
	$host = $title,
	$port = '80',
	$root    = "/var/www/$host",
	$server_name = "_",
) {
	file { "$root":
		ensure => directory,
		owner  => 'www-data',
		group  => 'www-data',
		mode   => '0755',
	}

	file { 'test':
		ensure  => present,
		path    => "$root/index.html",
		owner   => 'www-data',
		group   => 'www-data',
		mode    =>  '0644',
		content => "<h1> This is th vhost $host</h1>",
	}

	exec { 'create sites':,
		path    => ['/usr/bin','/bin'],
		unless  => "/usr/bin/test -d  $root/sites-available && /usr/bin/test -d $root/sites-enabled",
		command => "/bin/mkdir  /opt/nginx/conf/sites-available && /bin/mkdir /opt/nginx/conf/sites-enabled"
	}

	#service {'nginx':

	
}


