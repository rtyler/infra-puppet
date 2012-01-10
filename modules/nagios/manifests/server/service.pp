class nagios::server::service {
  service {
    "nagios3" :
      ensure  => running,
      alias   => "nagios",
      hasstatus       => true,
      hasrestart      => true,
      require => Class["nagios::server::packages"],
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
