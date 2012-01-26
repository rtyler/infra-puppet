class nagios::server::permissions() {
  # For some dumbass reason, the nagios_host and nagios_service configs get
  # written with a 600 mode
  exec {
    "fix-nagios-perms" :
      refreshonly => true,
      command     => "chmod 644 ${nagios::server::jenkins_cfg_dir}/*.cfg",
      require     => File["${nagios::server::jenkins_cfg_dir}"],
      notify      => Service["nagios"];
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
