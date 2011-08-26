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
    include mirrorbrain::files
    include mirrorbrain::tree
    include mirrorbrain::repos
    include mirrorbrain::packages

    Class["mirrorbrain::repos"] ->
        Class["mirrorbrain::packages"] ->
            Class["mirrorbrain::tree"] ->
                Class["mirrorbrain::files"]
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
        "apache2-mod_geoip" :
            ensure => installed,
            require => Package["apache2"];
        "apache2-mod_asn" :
            ensure => installed,
            require => Package["apache2"];
        "apache2-mod_form" :
            ensure => installed,
            require => Package["apache2"];
        "apache2-mod_mirrorbrain" :
            ensure => installed,
            require => [
                        Package["apache2"],
                        Package["apache2-mod_geoip"]
                       ];

        "postgresql-devel" :
            ensure => installed;

        # Python dependencies
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
        "/etc/apache2" :
            ensure  => directory,
            require => Class["pkg-apache2"];

        "/etc/apache2/vhosts.d" :
            ensure  => directory,
            require => [
                        Class["pkg-apache2"],
                        File["/etc/apache2"]
                       ];

        "/etc/sysconfig/apache2" :
            ensure => directory,
            require => [
                        Class["pkg-apache2"]
                       ];
    }
}

class mirrorbrain::files {
    file {
        "/etc/apache2/vhosts.d/mirrors.conf" :
            ensure  => present,
            require => Class["pkg-apache2"],
            source  => "puppet:///modules/mirrorbrain/virtualhost.conf";

        "/etc/sysconfig/apache2/geoip.conf" :
            ensure  => present,
            require => [
                        Class["pkg-apache2"],
                        File["/etc/sysconfig/apache2"]
                       ],
            source  => "puppet:///modules/mirrorbrain/geoip.conf";
    }
}
