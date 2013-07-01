#
# Nginx server
#
class nginx {
  if $operatingsystem != "Ubuntu" {
    err("The nginx module is not configured for $operatingsystem")
  }

  package {
    "nginx" :
      ensure  => installed;
  }

  service {
    "nginx" :
      ensure   => running,
      require => Package["nginx"],
      hasstatus     => true,
      hasrestart    => true,
      enable  => true;
  }

  file {
    "/etc/nginx/sites-enabled/default":
      ensure => absent
  }

  exec {
    "reload-nginx" :
      refreshonly => true,
      command => "/etc/init.d/nginx reload",
      require => Package["nginx"];

    "restart-nginx" :
      refreshonly => true,
      command => "/etc/init.d/nginx restart",
      require => Package["nginx"];
  }
}
