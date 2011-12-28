

class temp-dns {
    package {
    'bind' :
        ensure => present,
        name   => 'bind9';

    'bind-utils' :
        ensure => present,
        name   => 'dnsutils';
  }

    file {
        "/etc/bind/jenkins-ci.org.zone" :
            ensure  => present,
            owner   => bind,
            group   => bind,
            require => Package["bind"],
            notify  => Service["bind"],
            source  => "puppet:///modules/temp-dns/jenkins-ci.org.zone";

        "/etc/bind/named.conf.local" :
            ensure  => present,
            owner   => bind,
            group   => bind,
            notify  => Service["bind"],
            require => [
                        File["/etc/bind/jenkins-ci.org.zone"],
                        Package["bind"]
            ],
            source => "puppet:///modules/temp-dns/named.conf.local";
    }

    service {
        "bind" :
            ensure  => running,
            require => Package['bind'],
            name    => 'bind9';
    }
}
# vim: shiftwidth=4 expandtab tabstop=4
