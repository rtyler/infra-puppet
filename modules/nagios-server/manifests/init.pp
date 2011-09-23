
class nagios-server {
    if $operatingsystem != "Ubuntu" {
        err("The nagios-server module isn't supported for $operatingsystem")
    }
    else {
        include  nagios-server::ubuntu
    }

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
}
