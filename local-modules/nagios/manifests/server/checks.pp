#
# This is kind of a giant dump of all checks we need to run. This will
# definitely need to be cleaned-up or refactored at some point
#
class nagios::server::checks() {
  include nagios::server
  nagios_service {
    "mirrorbrain check" :
      target => "${nagios::server::jenkins_cfg_dir}/mirrorbrain_check.cfg",
      notify     => [
                Service["nagios"],
                Class['nagios::server::permissions'],
                File["${nagios::server::commands::mirrorbrain_file}"],
                Nagios_Command["check_mirrorbrain"],
      ],
      ensure              => present,
      contact_groups      => "core-admins",
      service_description => "MirrorBrain",
      host_name           => "cucumber.jenkins-ci.org",
      use                 => "generic-service",
      check_command       => "check_mirrorbrain";
  }
  ##############################################################################

  nagios::server::check-http {
    "cucumber" :
      # Runs: www, mirrors, updates
      ;
    "eggplant" :
      # Runs: wiki, issues
      ;
  }

  nagios::server::check-https {
    "cucumber" :
      # Runs: www, mirrors, updates
      ;
    "eggplant" :
      # Runs: wiki, issues
      ;
  }

}
# vim: shiftwidth=2 expandtab tabstop=2
