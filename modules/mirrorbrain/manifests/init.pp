#
#   Manifest responsible for driving a the MirrorBrain installation behind
#   mirrors.jenkins-ci.org

class mirrorbrain {
    if $operatingsystem == "CentOS" {
        include  mirrorbrain::centos
    }
    else {
        err("MirrorBrain is currently only configured for CentOS hosts")
    }

    include pkg-apache2
    Class["pkg-apache2"] -> Class["mirrorbrain::centos"]
}

class mirrorbrain::centos {
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
}


class mirrorbrain::repos {
    yumrepo {
        "MirrorBrain" :
            baseurl => "http://download.opensuse.org/repositories/Apache:/MirrorBrain/CentOS_5/",
            descr => "MirrorBrain OBS repo",
            enabled => 1,
            gpgcheck => 0;
    }
}

class mirrorbrain::packages {
    package {
        "mod_geoip" :
            ensure => installed,
            require => Package["apache2"];

        "postgresql-devel" :
            ensure => installed;

        # Python dependencies

        # Needed to build the stupid mb tools
        "python-devel" :
            ensure => installed;

        "python-psycopg2" :
            require => Package["postgresql-devel"],
            ensure => installed;
        "python-sqlobject" :
            ensure => installed;
        "python-cmdln" :
            ensure => installed;
    }
}

class mirrorbrain::tree {
    file {
        "/etc/httpd" :
            ensure  => directory,
            require => Class["pkg-apache2"];

        "/etc/httpd/conf.d" :
            ensure  => directory,
            require => [
                        Class["pkg-apache2"],
                        File["/etc/httpd"]
                       ];
    }
}

class mirrorbrain::files {
    file {
        "/etc/httpd/conf.d/mirrors.conf" :
            ensure  => present,
            require => Class["pkg-apache2"],
            source  => "puppet:///modules/mirrorbrain/virtualhost.conf";

        "/etc/httpd/conf.d/geoip.conf" :
            ensure  => present,
            require => [
                        Class["pkg-apache2"]
                       ],
            source  => "puppet:///modules/mirrorbrain/geoip.conf";


        "/etc/mirmon.conf" :
            ensure  => present,
            source  => "puppet:///modules/mirrorbrain/mirmon.conf";

        "/etc/mirrorbrain.conf" :
            ensure  => present,
            source  => "puppet:///modules/mirrorbrain/mirrorbrain.conf";
    }
}

class mirrorbrain::cron {
    # These crontabs temporarily disabled since this manifest isn't properly
    # taking care of installing the actual mirrorbrain package. Sadness

    #cron {
    #    "mirrorprobe" :
    #        command => "mirrorprobe",
    #        user    => root,
    #        minute  => 30,
    #        ensure  => present;

    #    "mb scan" :
    #        command => "mb scan --quiet --jobs 4 --al",
    #        user    => root,
    #        minute  => 45,
    #        ensure  => present;

    #    "mb vacuum" :
    #        command => "mb db vacuum",
    #        user    => root,
    #        minute  => 30,
    #        hour    => 1,
    #        weekday => Monday,
    #        ensure  => present;

    #    #"geoip-lite-update" :
    #    #    command => "geoip-lite-update",
    #    #    user    => root,
    #    #    minute  => 45,
    #    #    hour    => 4,
    #    #    weekday => Tuesday,
    #    #    ensure  => present;
    #}
}
