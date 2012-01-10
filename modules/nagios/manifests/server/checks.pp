#
# This is kind of a giant dump of all checks we need to run. This will
# definitely need to be cleaned-up or refactored at some point
#
class nagios::server::checks($config_dir) {
  include nagios::server

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
