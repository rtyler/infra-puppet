class nagios::server::contacts($config_dir) {
  nagios_contactgroup {
    "admins" :
      notify            => [
                    Service["nagios"],
                    Class['nagios::server::permissions']
      ],
      contactgroup_name => "core-admins",
      alias             => "Nagios Core Admins",
      members           => "pagerduty",
      target            => "${config_dir}/pagerduty_contact_group.cfg";
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
