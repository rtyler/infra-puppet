class nagios::server::contacts() {
  nagios_contactgroup {
    "admins" :
      notify            => [
                    Service["nagios"],
                    Class['nagios::server::permissions']
      ],
      contactgroup_name => "core-admins",
      alias             => "Nagios Core Admins",
      members           => "pagerduty",
      target            => "${nagios::server::jenkins_cfg_dir}/pagerduty_contact_group.cfg";
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
