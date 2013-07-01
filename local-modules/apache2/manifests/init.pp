class apache2 {
  if $operatingsystem != "Ubuntu" {
    err("The apache2 module is not configured for $operatingsystem")
  }
  else {
    package {
      "apache2" :
        alias => "apache2",
        ensure  => installed;
    }

    service {
      "apache2" :
        ensure   => running,
        require => Package["apache2"],
        hasstatus     => true,
        hasrestart    => true,
        enable  => true;
    }
  }
}
