#
# This is kind of a giant dump of all checks we need to run. This will
# definitely need to be cleaned-up or refactored at some point
#
class nagios::server::checks($config_dir) {
  include nagios::server

  # Simple mirrorbrain check
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
      notify       => [
                      Service["nagios"],
                      Class["nagios::server::permissions"],
                      ],
      ensure       => present,
      #use         => "generic-command",
      command_line => $mirrorbrain_file;
  }
  nagios_service {
    "mirrorbrain check" :
      target => "${nagios::server::jenkins_cfg_dir}/mirrorbrain_check.cfg",
      notify     => [
                Service["nagios"],
                Class['nagios::server::permissions'],
                File[$mirrorbrain_file],
                Nagios_Command["check_mirrorbrain"],
      ],
      ensure              => present,
      contact_groups      => "core-admins",
      service_description => "MirrorBrain",
      host_name           => "cucumber.jenkins-ci.org",
      use                 => "generic-service",
      check_command       => "check_mirrorbrain";
  }

  nagios::server::check-http {
    "cucumber" :
      # Runs: www, mirrors, updates
      name => "cucumber";
    "eggplant" :
      # Runs: wiki, issues
      name => "eggplant";
  }

  nagios::server::check-https {
    "cucumber" :
      # Runs: www, mirrors, updates
      name => "cucumber";
    "eggplant" :
      # Runs: wiki, issues
      name => "eggplant";
  }

  nagios_command {
    "check_disk_by_ssh":
      command_line  => "\$USER1\$/check_by_ssh -H \$HOSTADDRESS\$ -C \"/usr/lib/nagios/plugins/check_disk -w \$ARG1\$ -c \$ARG2\$ -p /\"",
      notify      => Service["nagios"],
      target      => "${$config_dir}/check_disk_by_ssh.cfg",
      ensure      => present
  }

  nagios::server::check-disk {
    "eggplant" :
      name => "eggplant";
    "cabbage" :
      name => "cabbage";
    "spinach" :
      name   => "spinach";
    "cucumber" :
      name   => "cucumber",
      ensure => absent;
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
