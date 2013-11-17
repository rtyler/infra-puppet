class exim4_config::functions {
  exec {
    "reload-exim4" :
      refreshonly => true,
      command => "update-exim4.conf; /etc/init.d/exim4 reload",
      require => Package["exim4"];
  }
}

