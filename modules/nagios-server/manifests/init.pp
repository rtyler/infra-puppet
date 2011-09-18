
class nagios-server {
    group {
        "nagios" :
            ensure  => present;
    }

    user {
        "nagios" :
            ensure  => present,
            require => [
                        File["/etc/nagios"],
                        Group["nagios"]
                       ];
    }


    file {
        "/etc/nagios" :
            ensure  => directory,
            require => [
                        Group["nagios"],
                        Package["nagios"],
                        Package["nagios-plugins"],
                        Package["nagios-nrpe"]
                       ]
    }


    if $operatingsystem != "Ubuntu" {
        err("The nagios-server module isn't supported for $operatingsystem")
    }
    else {
        include  nagios-server::ubuntu
    }
}
