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


class mirrorbrain::repos {
    file {
        "/etc/apt/sources.list.d" :
            ensure => directory;

        "/etc/apt/sources.list.d/mirrorbrain.list" :
            ensure => present,
            notify => [
                        Exec["install-key"],
                        Exec["refresh-apt"],
                      ],
            source => "puppet:///modules/mirrorbrain/apt.list",
    }

    file {
        "/root/mirrorbrain.key" :
            source => "puppet:///modules/mirrorbrain/Release.key",
            ensure => present;
    }

    exec {
        "refresh-apt" :
            refreshonly => true,
            require => [
                        File["/etc/apt/sources.list.d/mirrorbrain.list"],
                        Exec["install-key"],
                       ],
            command => "apt-get update";

        "install-key" :
            notify => Exec["refresh-apt"],
            require => [
                        File["/etc/apt/sources.list.d/mirrorbrain.list"],
                        File["/root/mirrorbrain.key"],
                       ],
            command => "/usr/bin/apt-key add /root/mirrorbrain.key";
    }
}

class mirrorbrain::packages {
    package {
        "libapache2-mod-geoip" :
            ensure => installed,
            require => Package["apache2"];

        "libapache2-mod-mirrorbrain" :
            ensure => installed,
            require => Package["apache2"];

        "mirrorbrain" :
            ensure => installed;

        "mirrorbrain-scanner" :
            ensure => installed;

        "mirrorbrain-tools" :
            ensure => installed;

        "postgresql-server-dev-8.4" :
            ensure => installed;

        "mirmon" :
            ensure => installed;

        # Python dependencies
        ######################################
        # Needed to build the stupid mb tools
        "python-dev" :
            ensure => installed;

        "python-psycopg2" :
            require => Package["postgresql-server-dev-8.4"],
            ensure => installed;
        "python-sqlobject" :
            ensure => installed;
        "python-cmdln" :
            ensure => installed;
    }
}

class mirrorbrain::tree {
    file {
        # Make sure the directory tree for MirrorBrain to mirror exists
        "/srv" :
            ensure => directory;
        "/srv/releases" :
            ensure => directory;
        "/srv/releases/jenkins" :
            ensure => directory;


        "/srv/releases/jenkins/index.html" :
            ensure => present,
            source => "puppet:///modules/mirrorbrain/index.html",
            require => File["/srv/releases/jenkins"];


        "/var/log/apache2" :
            ensure => directory;
        "/var/log/apache2/mirrors.jenkins-ci.org" :
            ensure => directory,
            require => File["/var/log/apache2"];
    }
}

class mirrorbrain::files {
    file {
        "/etc/apache2/sites-available/mirrors.jenkins-ci.org" :
            ensure  => present,
            require => Class["apache2"],
            source  => "puppet:///modules/mirrorbrain/virtualhost.conf";

        "/etc/apache2/mods-available/geoip.conf" :
            ensure  => present,
            require => [
                        Class["apache2"]
                       ],
            source  => "puppet:///modules/mirrorbrain/geoip.conf";

        "/etc/apache2/mods-available/dbd.conf" :
            ensure => present,
            require => Class["apache2"],
            source => [
                        "puppet:///modules/mirrorbrain/dbd.conf.private",
                        "puppet:///modules/mirrorbrain/dbd.conf",
                      ];


        "/etc/mirmon.conf" :
            ensure  => present,
            source  => "puppet:///modules/mirrorbrain/mirmon.conf";

        "/etc/mirrorbrain.conf" :
            ensure  => present,
            source  => "puppet:///modules/mirrorbrain/mirrorbrain.conf";
    }

    enable-apache-site {
        "mirrors.jenkins-ci.org" :
            name => "mirrors.jenkins-ci.org",
            require => File["/etc/apache2/sites-available/mirrors.jenkins-ci.org"];
    }
}
