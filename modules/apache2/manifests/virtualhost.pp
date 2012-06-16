define apache2::virtualhost($source) {
  include apache2::functions

  file { "/etc/apache2/sites-available/${name}":
    owner   => root,
    group   => root,
    mode  => 644,
    source  => $source,
    require => Package["apache2"],
  }
  file { "/etc/apache2/sites-enabled/${name}":
    ensure  => "../sites-available/${name}",
    notify  => Exec["reload-apache2"],
  }

  # directory to house log files
  file { "/var/log/apache2/${name}":
    ensure  => directory,
    owner   => root,
    mode  => 700
  }
}
