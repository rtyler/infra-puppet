# Contents of this file borrowed from Michael Gurski:
# <http://blog.gurski.org/index.php/2010/01/28/automatic-monitoring-with-puppet-and-nagios/>


class nagios-server::defines {
}

define basic-nagios-host($name, $full_name, $os = "ubuntu") {
    $cfg_root = "/etc/nagios3/conf.d/jenkins"

    nagios_host {
        $full_name :
            ensure         => present,
            alias          => $name,
            contact_groups => "core-admins",
            check_command  => "check_ssh_4",
            target         => "${cfg_root}/${name}_host.cfg",
            notify         => Service["nagios"],
            use            => "generic-host";
    }

    nagios_hostextinfo {
        $full_name:
            ensure => present,
            notify => Service["nagios"],
            icon_image_alt => $os,
            icon_image => "base/${os}.png",
            statusmap_image => "base/${os}.gd2",
            target => "${cfg_root}/${name}_hostextinfo.cfg",
    }

    # Disable ping checks for cucumber. It has unmanaged iptable rules that
    # drop all inbound ICMP traffic. I'd rather fix those iptable rules once
    # cucumber is more properly managed by puppet
    if ($name != "cucumber") {
        nagios_service {
            "check_ping_${name}":
                target                => "${cfg_root}/${name}_service.cfg",
                notify                => Service["nagios"],
                ensure                => present,
                contact_groups        => "core-admins",
                service_description   => "Ping",
                check_command         => "check-host-alive",
                host_name             => "$full_name",
                notification_interval => 5,
                use                   => "generic-service",
        }
    }

    nagios_service {
        "check_ssh_${name}":
            target                => "${cfg_root}/${name}_service.cfg",
            notify                => Service["nagios"],
            ensure                => present,
            contact_groups        => "core-admins",
            service_description   => "SSH",
            check_command         => "check_ssh_4",
            host_name             => "$full_name",
            notification_interval => 5,
            use                   => "generic-service",
    }
}
# vim: shiftwidth=4 expandtab tabstop=4
