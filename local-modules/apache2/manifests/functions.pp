class apache2::functions {
  exec {
    "reload-apache2" :
      refreshonly => true,
      command => "/etc/init.d/apache2 reload",
      require => Package["apache2"];

    "restart-apache2" :
      refreshonly => true,
      command => "/etc/init.d/apache2 restart",
      require => Package["apache2"];
  }
}

