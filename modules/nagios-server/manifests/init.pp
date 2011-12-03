
class nagios-server {
    include nagios-server::packages

    group {
        "nagios" :
            ensure  => present;
    }

    user {
        "nagios" :
            gid     => nagios,
            ensure  => present,
            require => [
                        File["/etc/nagios"],
                        Group["nagios"]
                       ];
    }

    service {
        "nagios3" :
          ensure  => running,
          alias   => "nagios",
          hasstatus       => true,
          hasrestart      => true,
          require => Class["nagios-server::packages"],
    }


    file {
        "/etc/nagios" :
            ensure  => directory,
            require => [
                        Group["nagios"],
                        Class["nagios-server::packages"],
                       ]
    }
}

class nagios-server::packages {
    package {
        "libwww-perl" :
            ensure  => installed;

        "libcrypt-ssleay-perl" :
            ensure  => installed;

        "nagios3" :
            ensure  => installed;

        "nagios-plugins-extra" :
            ensure  => installed;

        "nagios-nrpe-plugin" :
            ensure  => installed;
    }
}
