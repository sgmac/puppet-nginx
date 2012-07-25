## Puppet Nginx Module

This module installs Nginx using [puppet-rvm](https://github.com/blt04/puppet-rvm). Please, read the documentation before you begin. This module has been tested on Debian Squeeze 6.0.5. For custom types, do not forget to enable pluginsync: 
```
[main]
pluginsync = true

```

### Basic usage

Install nginx with

```
include nginx
```

By default installs on _/opt/nginx_, there are some variables you might override

```
$ruby_version      = 'ruby-1.9.3-p125'
$passenger_version = '3.0.12'
$installdir	   = '/opt/nginx'
$logdir		   = '/var/log/nginx'
$www		   = '/var/www'
```
A custom installation might look like this:

``` 
node webserver { 
    class { 'nginx':
	 $installdir => '/usr/local/nginx',
	 $logdir     => '/usr/local/logs/nginx',
    }
}
```

### Virtual Hosts

You can easily configure a virtual hosts. An example is:

```
nginx::vhost { 'www.example.com':
	port => '8080'
	rails => true,
}
```
The _rails_ attribute is optional and set to false by default. However, if you want to deploy a rails app, use this attribute and the rails template will be used instead.

### MIT License 

Copyright (C) 2012 by Sergio Galván

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
