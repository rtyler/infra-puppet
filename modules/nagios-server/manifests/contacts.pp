class nagios-server::contacts {
    $nagios_config_root = "/etc/nagios3/conf.d/jenkins"

    nagios_contact {
        "rtyler" :
            notify                        => Service["nagios"],
            contact_name                  => "rtyler",
            alias                         => "R Tyler Croy",
            ensure                        => present,
            email                         => "tyler--jenkinsalerts@monkeypox.org",
            service_notification_period   => "24x7",
            host_notification_period      => "24x7",
            service_notification_commands => "notify-service-by-email",
            host_notification_commands    => "notify-host-by-email",
            target                        => "${nagios_config_root}/contacts.cfg";
    }

    nagios_contactgroup {
        "admins" :
            notify            => Service["nagios"],
            contactgroup_name => "core-admins",
            alias             => "Nagios Core Admins",
            members           => "rtyler,pagerduty",
            target            => "${nagios_config_root}/contact_groups.cfg";

    }
}
# vim: shiftwidth=4 expandtab tabstop=4
