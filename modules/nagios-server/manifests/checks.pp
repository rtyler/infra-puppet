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
}

define nagios-check-http ($name) {
    $nagios_config_root = "/etc/nagios3/conf.d/jenkins"

    nagios_service {
        "http check $name" :
            target              => "${nagios_config_root}/http_services.cfg",
            notify              => Service["nagios"],
            ensure              => present,
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
            service_description => "HTTPs",
            check_command       => "check_https_4",
            host_name           => "${name}.jenkins-ci.org",
            use                 => "generic-service",
    }
}
# vim: shiftwidth=4 expandtab tabstop=4
