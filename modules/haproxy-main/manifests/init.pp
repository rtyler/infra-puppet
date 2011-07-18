#
#   haproxy module for managing the main haproxy installation (currently
#   running on cucumber)
#

class haproxy-main {

    package {
        "haproxy" :
            ensure  => installed;
    }

    group {
        "haproxy" :
            gid     => 4402,
            ensure  => present;
    }

    user {
        "haproxy" :
            uid     => 4402,
            gid     => 4402,
            shell   => "/bin/false",
            ensure  => present,
            require => [
                        Group["haproxy"],
                        Package["haproxy"],
                       ];
    }

    file {
        "/etc/haproxy" :
            ensure  => directory,
            owner   => "haproxy",
            group   => "haproxy",
            require => User["haproxy"];

        "/etc/haproxy/haproxy.cfg" :
            ensure  => present,
            owner   => "haproxy",
            group   => "haproxy",
            require => User["haproxy"],
            source  => "puppet:///modules/haproxy-main/haproxy.cfg";
    }
}
