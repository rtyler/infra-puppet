class nagios::server::permissions($config_dir) {
  # For some dumbass reason, the nagios_host and nagios_service configs get
  # written with a 600 mode
  exec {
    "fix-nagios-perms" :
      refreshonly => true,
      command     => "chmod 644 ${config_dir}/*.cfg",
      require     => File[$config_dir],
      notify      => Service["nagios"];
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
