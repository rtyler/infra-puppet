
class nagios-server {
    include apache2
    include nagios-client
    class {
        "nagios-server::packages": ;
        "nagios-server::service" : ;
        "nagios-server::clients" : ;
        "nagios-server::perms"   : ;
        "nagios-server::checks"  : ;
        "nagios-server::contacts": ;
    }

    # nagios-client should always get run first since it will create the nagios
    # user and set up some basic permissions
    Class["nagios-client"] ->
        Class["nagios-server::packages"] ->
            Class["nagios-server"] ->
                Class["nagios-server::clients"] ->
                    Class["nagios-server::checks"] ->
                        Class["nagios-server::contacts"] ->
                            Class["nagios-server::perms"]


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
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/nagios.htpasswd";

        "/etc/nagios3/cgi.cfg" :
            ensure => present,
            require => [
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/nagios.cgi.cfg";

        "/etc/nagios3/nagios.cfg" :
            ensure => present,
            require => [
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/nagios.cfg";

        "/var/lib/nagios3" :
            ensure => directory,
            mode   => 751,
            require => [
                        Class["nagios-server::packages"],
            ];

        "/var/lib/nagios3/rw" :
            ensure  => directory,
            group   => "www-data",
            mode    => 2710,
            require => [
                        Class["nagios-server::packages"],
            ];

        "/etc/apache2/sites-enabled/nagios.jenkins-ci.org" :
            ensure  => present,
            require => [
                        Class["apache2"],
                        Class["nagios-server::packages"],
            ],
            source => "puppet:///modules/nagios-server/apache2.conf";


        # Nagios Pager Duty integration
        # Thanks pagerduty.com for the gratis account!
        "/usr/local/bin/pagerduty_nagios.pl" :
            ensure => present,
            mode   => 755,
            source => "puppet:///modules/nagios-server/pagerduty_nagios.pl";

        # Commented out, this file is dropped onto the host directly as it
        # contains the API key
        #"/etc/nagios3/conf.d/pagerduty_nagios.cfg" :
        #    ensure => present,
        #    require => [
        #                Class["nagios-server::packages"],
        #    ],
        #    source => "puppet:///modules/nagios-server/pagerduty_nagios.cfg";
    }

    cron {
        "pagerduty_flush" :
            command => "/usr/local/bin/pagerduty_nagios.pl",
            require => File["/usr/local/bin/pagerduty_nagios.pl"],
            user    => nagios;
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
