
class nagios-server {
    include apache2
    class {
        "nagios-server::packages": ;
        "nagios-server::service" : ;
        "nagios-server::clients" : ;
        "nagios-server::perms"   : ;
    }

    Class["nagios-server::packages"] ->
        Class["nagios-server"] ->
            Class["nagios-server::clients"] ->
                Class["nagios-server::perms"]


    group {
        "nagios" :
            ensure  => present;
    }

    user {
        "nagios" :
            gid     => nagios,
            ensure  => present,
            require => [
                        Group["nagios"]
                       ];
    }

    file {
        "/etc/nagios3/conf.d/jenkins" :
            ensure  => directory,
            mode    => 755,
            require => [
                        Group["nagios"],
                        Class["nagios-server::packages"],
            ];

        "/etc/nagios3/htpasswd.users" :
            ensure => present,
            require => [
                        Class["apache2"],
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/nagios.htpasswd";

        "/etc/nagios3/cgi.cfg" :
            ensure => present,
            require => [
                        Class["apache2"],
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/nagios.cgi.cfg";

        "/etc/apache2/sites-enabled/nagios.jenkins-ci.org" :
            ensure  => present,
            require => [
                        Class["apache2"],
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/apache2.conf";

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

class nagios-server::service {
    service {
        "nagios3" :
          ensure  => running,
          alias   => "nagios",
          hasstatus       => true,
          hasrestart      => true,
          require => Class["nagios-server::packages"],
    }
}

class nagios-server::perms {
    # For some dumbass reason, the nagios_host and nagios_service configs get
    # written with a 600 mode
    exec {
        "fix-nagios-perms" :
            command => "chmod 644 /etc/nagios3/conf.d/jenkins/*.cfg",
            notify => Service["nagios"];
    }
}

# vim: shiftwidth=4 expandtab tabstop=4
