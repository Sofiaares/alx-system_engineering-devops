# Add Stable Version of nginx :
exec { 'add nginx stable repo':
  command => 'sudo add-apt-repository ppa:nginx/stable',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  unless  => 'apt-cache policy nginx | grep -q "nginx/stable"',
  require => Class['apt'],
}

# Update software packages list
class { 'apt': }

# Install nginx
package { 'nginx':
  ensure => 'installed',
}

# Allow HTTP
firewall { 'allow HTTP':
  port   => 80,
  proto  => 'tcp',
  action => 'accept',
}

# Change folder rights
file { '/var/www':
  ensure => 'directory',
  mode   => '0755',
  recurse => true,
}

# Create index file
file { '/var/www/html/index.html':
  content => "Hello World!\n",
}

# Create 404 page
file { '/var/www/html/404.html':
  content => "Ceci n'est pas une page\n",
}

# Configure Nginx
file { '/etc/nginx/sites-enabled/default':
  ensure  => file,
  content => template('module/nginx.conf.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Restart Nginx
service { 'nginx':
  ensure => running,
  enable => true,
  require => Package['nginx'],
  subscribe => File['/etc/nginx/sites-enabled/default'],
}
