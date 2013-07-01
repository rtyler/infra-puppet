define nginx::virtualhost($source) {
  file { "/etc/nginx/sites-available/${name}":
    owner   => root,
    group   => root,
    mode  => 644,
    source  => $source,
    require => Package["nginx"],
    notify  => Exec["reload-nginx"],
  }
  file { "/etc/nginx/sites-enabled/${name}":
    ensure  => "../sites-available/${name}",
    notify  => Exec["reload-nginx"],
    require => Package["nginx"],
  }

  # directory to house log files
  file { "/var/log/nginx/${name}":
    ensure  => directory,
    owner   => root,
    mode  => 700
  }
}
