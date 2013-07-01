define apache2::virtualhost($source=undef, $content=undef) {
  include apache2::functions

  file { "/etc/apache2/sites-available/${name}":
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => $source,
    content => $content,
    require => Package['apache2'],
    notify  => Exec['reload-apache2'],
  }
  file { "/etc/apache2/sites-enabled/${name}":
    ensure  => "../sites-available/${name}",
    notify  => Exec['reload-apache2'],
  }

  # directory to house log files
  file {
    "/var/log/apache2/${name}":
      ensure  => directory,
      owner   => root,
      mode    => '0700';
    "/var/www/${name}" :
      ensure  => directory,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0755';
  }
}
