#
#   Manifest responsible for driving a the MirrorBrain installation behind
#   mirrors.jenkins-ci.org

class mirrorbrain {
    if $operatingsystem != "Ubuntu" {
        err("The mirrorbrain module is currently only functional for Ubuntu hosts")
    }

    include mirrorbrain::ubuntu
    include apache2
    Class["apache2"] -> Class["mirrorbrain::ubuntu"]
}

class mirrorbrain::ubuntu {
    include mirrorbrain::cron
    include mirrorbrain::files
    include mirrorbrain::tree
    include mirrorbrain::repos
    include mirrorbrain::packages

    Class["mirrorbrain::repos"] ->
        Class["mirrorbrain::packages"] ->
            Class["mirrorbrain::tree"] ->
                Class["mirrorbrain::files"] ->
                    Class["mirrorbrain::cron"]


    enable-apache-mod {
        "mirrorbrain":
            name => "mirrorbrain",
            require => Class["mirrorbrain::packages"];

        "geoip" :
            name => "geoip",
            require => [
                        Class["mirrorbrain::packages"],
                        Class["mirrorbrain::files"],
                        ];

        # Required for mirrorbrain to access postgresql
        "dbd" :
            name => "dbd",
            require => [
                        Package["apache2"],
                        Class["mirrorbrain::files"],
                       ];
    }
}
