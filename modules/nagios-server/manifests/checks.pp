#
# This is kind of a giant dump of all checks we need to run. This will
# definitely need to be cleaned-up or refactored at some point
#
class nagios-server::checks {
    nagios-check-http {
        "cucumber" :
            # Runs: www, mirrors, updates
            name => "cucumber";
        "eggplant" :
            # Runs: wiki, issues
            name => "eggplant";
    }

    nagios-check-https {
        "cucumber" :
            # Runs: www, mirrors, updates
            name => "cucumber";
        "eggplant" :
            # Runs: wiki, issues
            name => "eggplant";
    }

    # Define how Nagios monitors remote disk via SSH login
    $nagios_config_root = "/etc/nagios3/conf.d/jenkins"
    nagios_command {
        "check_disk_by_ssh":
            command_line    => "\$USER1\$/check_by_ssh -H \$HOSTADDRESS\$ -C \"/usr/lib/nagios/plugins/check_disk -w \$ARG1\$ -c \$ARG2\$\"",
            notify          => Service["nagios"],
            target          => "${nagios_config_root}/check_disk_by_ssh.cfg",
            ensure          => present
    }

    nagios-check-disk {
        "eggplant" :
            name => "eggplant";
        "cucumber" :
            name => "cucumber";
    }
}

define nagios-check-http ($name) {
    $nagios_config_root = "/etc/nagios3/conf.d/jenkins"

    nagios_service {
        "http check $name" :
            target              => "${nagios_config_root}/http_services.cfg",
            notify              => Service["nagios"],
            ensure              => present,
            contact_groups      => "core-admins",
            service_description => "HTTP",
            check_command       => "check_http_4",
            host_name           => "${name}.jenkins-ci.org",
            use                 => "generic-service",
    }
}

define nagios-check-https ($name) {
    $nagios_config_root = "/etc/nagios3/conf.d/jenkins"

    nagios_service {
        "https check ${name}" :
            target              => "${nagios_config_root}/http_services.cfg",
            notify              => Service["nagios"],
            ensure              => present,
            contact_groups      => "core-admins",
            service_description => "HTTPs",
            check_command       => "check_https_4",
            host_name           => "${name}.jenkins-ci.org",
            use                 => "generic-service",
    }
}

# set up the disk monitoring service for the given host
define nagios-check-disk ($name) {
    $nagios_config_root = "/etc/nagios3/conf.d/jenkins"

    nagios_service {
        "disk check $name" :
            target              => "${nagios_config_root}/disk.cfg",
            notify              => Service["nagios"],
            ensure              => present,
            contact_groups      => "core-admins",
            service_description => "Disk availability",
            check_command       => "check_disk_by_ssh!2000!1000",  # warning at 2GB, critical at 1GB. (otherwise use 10%, etc)
            host_name           => "${name}.jenkins-ci.org",
            use                 => "generic-service",
    }
}

# vim: shiftwidth=4 expandtab tabstop=4
