class exim4-config::functions {
  include exim4-config
  exec {
    "reload-exim4" :
      refreshonly => true,
      command => "/bin/sh -c 'update-exim4.conf && /etc/init.d/exim4 reload'",
      require => Package["exim4"];
  }
}

