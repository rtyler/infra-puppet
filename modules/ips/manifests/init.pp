#
#   Run pkg.depotd servers for
#   mirrors.jenkins-ci.org
#

define ips::repository($name,$port) {
    # empty place holder for the repository
    file { "/srv/ips/ips$name":
        ensure => directory,
        mode => 755,
        owner  => "ips";
    }

    # reverse proxy configuration
    file { "/etc/apache2/sites-available/ips$name.conf":
        owner => "ips",
        content => template("ips/reverse-proxy.conf.erb");
    }

    # upstart script
    file { "/etc/init/pkg.depotd$name":
        owner => "root",
        group => "root",
        content => template("ips/pkg.depotd.conf.erb");
    }

    # SysV init compatibility layer
    file { "/etc/init.d/pkg.depotd$name":
        ensure => "/lib/init/upstart-job";
    }

    service { "pkg.depotd$name":
        ensure => "running";
    }
}

class ips {
    # this service uses Apache as a frontend
    include pkg-apache2
    Class["pkg-apache2"] -> Class["ips"]

    package {
        "ips" :
            ensure => installed,
            source => "puppet:///modules/ips/ips_2.3.54-0_all.deb";
    }

    group {
        "ips" :
            ensure  => present;
    }

    # ips repositories run in a separate user
    user {
        "ips" :
            shell   => "/usr/bin/zsh",
            home    => "/srv/ips",
            ensure  => present,
            require => [
                Package["zsh"]
            ];
    }

    file {
        "/srv/ips/.ssh" :
            ensure      => directory,
            recurse     => true,
            owner       => "ips",
            group       => "ips";

        "/var/log/apache2/ips.jenkins-ci.org":
            ensure      => directory,
            owner       => "root",
            group       => "root";

        "/etc/apache2/sites-available/ips.jenkins-ci.org":
            ensure      => directory,
            owner       => "root",
            group       => "root",
            source      => "puppet:///modules/ips/ips.jenkins-ci.org";

        "/etc/apache2/sites-enabled/ips.jenkins-ci.org":
            ensure      => "../sites-available/ips.jenkins-ci.org";

        "/var/www/ips.jenkins-ci.org":
            source      => "puppet:///modules/ips/www/index.html";
    }

    exec {
        "a2enmod proxy_http":
    }

    ssh_authorized_key {
        "ips" :
            user        => "ips",
            ensure      => present,
            require     => File["/srv/ips/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEArSave9EBJ2rP3Hm5PFyiOpfGsPhJwjqdyaVEwQruM0Fa8nWstla7cdSTSs/ClHn7I1uUzQvX+/+6m/HTVy/WIr0cIIxLDm8hXVLfCLddtvxnXx47fJY3ongasYJ4TarIGkMMX/Vg1JpP7XIkMczUSNRyeHg/bGfV+YCPFuSW+cj2M5yMOE1KyIVQQL/JZu7lu80Ara5+RWSITObdiHRpnNzvBdIyhkSCrG0N7QStIBnEaLU//K2AB5GbK/65+k7sklutcH18wSGridQCNJm4ODUxov+vVr2OH3oiv7gyHEE9TypRI9vS0HUmsD+moPq3O8y0xyP8xaJWkz2LKe8/5Q==",
            type        => "rsa",
            name        => "kohsuke@unicorn.2010/ips";
    }

    # repository definitions
    ips::repository {
        "main":
            name => "",
            port => 8060;
        "stable":
            name => "-stable",
            port => 8061;
        "rc":
            name => "-rc",
            port => 8062;
        "stable-rc":
            name => "-stable-rc",
            port => 8063;
    }
}