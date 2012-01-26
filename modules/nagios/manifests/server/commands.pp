class nagios::server::commands {
  nagios_command {
    "check_disk_by_ssh":
      command_line => "\$USER1\$/check_by_ssh -H \$HOSTADDRESS\$ -C \"/usr/lib/nagios/plugins/check_disk -w \$ARG1\$ -c \$ARG2\$ -p /\"",
      notify       => [
                      Service["nagios"],
                      Class["nagios::server::permissions"],
                      ],
      require      => File["${nagios::server::jenkins_cfg_dir}"],
      target       => "${nagios::server::jenkins_cfg_dir}/check_disk_by_ssh.cfg",
      ensure       => present
  }

  # Check to make sure last puppet run applied properly
  ##############################################################################
  nagios_command {
    "check_puppet_run_by_ssh" :
      target  => "${nagios::server::jenkins_cfg_dir}/puppet_run_command.cfg",
      require => File["${nagios::server::jenkins_cfg_dir}"],
      notify  => [
                      Service["nagios"],
                      Class["nagios::server::permissions"],
                      ],
      ensure       => present,
      command_line  => "\$USER1\$/check_by_ssh -H \$HOSTADDRESS\$ -C \"! test -f /root/infra-puppet/last_run_failed\"";
  }

  ##############################################################################

  # Simple mirrorbrain check
  ##############################################################################
  $mirrorbrain_file = "/usr/local/bin/check_mirrorbrain.sh"
  file {
    $mirrorbrain_file :
      ensure => present,
      owner  => root,
      mode   => 0755,
      source => "puppet:///modules/nagios/check_mirrorbrain.sh";
  }
  nagios_command {
    "check_mirrorbrain" :
      target       => "${nagios::server::jenkins_cfg_dir}/mirrorbrain_command.cfg",
      require      => File["${nagios::server::jenkins_cfg_dir}"],
      notify       => [
                      Service["nagios"],
                      Class["nagios::server::permissions"],
                      ],
      ensure       => present,
      command_line => $mirrorbrain_file;
  }
}
