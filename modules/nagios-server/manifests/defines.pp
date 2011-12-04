# Contents of this file borrowed from Michael Gurski:
# <http://blog.gurski.org/index.php/2010/01/28/automatic-monitoring-with-puppet-and-nagios/>


class nagios-server::defines {
}

define basic-nagios-host($name, $full_name, $os = "ubuntu") {
    $cfg_root = "/etc/nagios3/conf.d/jenkins"

    nagios_host {
        $full_name :
            ensure => present,
            alias  => $name,
            target => "${cfg_root}/${name}_host.cfg",
            notify => Service["nagios"],
            use    => "generic-host";
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

    nagios_service {
        "check_ping_${name}":
            target              => "${cfg_root}/${name}_service.cfg",
            notify              => Service["nagios"],
            ensure              => present,
            service_description => "Ping",
            check_command       => "check-host-alive",
            host_name           => "$full_name",
            use                 => "generic-service",
    }

    nagios_service {
        "check_ssh_${name}":
            target              => "${cfg_root}/${name}_service.cfg",
            notify              => Service["nagios"],
            ensure              => present,
            service_description => "SSH",
            check_command       => "check_ssh_4",
            host_name           => "$full_name",
            use                 => "generic-service",
    }

    #nagios_service {
    #    "check_users_${name}":
    #        use => "remote-nrpe-users",
    #        target => "${cfg_root}/${name}_host.cfg",
    #        host_name => "$full_name",
    #}

    #nagios_service {
    #    "check_load_${name}":
    #        use => "remote-nrpe-load",
    #        target => "${cfg_root}/${name}_host.cfg",
    #        host_name => "$full_name",
    #}

    #nagios_service {
    #    "check_zombie_procs_${name}":
    #        use => "remote-nrpe-zombie-procs",
    #        target => "${cfg_root}/${name}_host.cfg",
    #        host_name => "$full_name",
    #}

    #nagios_service {
    #    "check_total_procs_${name}":
    #        use => "remote-nrpe-total-procs",
    #        target => "${cfg_root}/${name}_host.cfg",
    #        host_name => "$full_name",
    #}

    #nagios_service {
    #    "check_swap_${name}":
    #        use => "remote-nrpe-swap",
    #        target => "${cfg_root}/${name}_host.cfg",
    #        host_name => "$full_name",
    #}

    #nagios_service {
    #    "check_all_disks_${name}":
    #        use => "remote-nrpe-all-disks",
    #        target => "${cfg_root}/${name}_host.cfg",
    #        host_name => "$full_name",
    #}
}
# vim: shiftwidth=4 expandtab tabstop=4
