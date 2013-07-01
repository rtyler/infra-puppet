#
#   Manifest necessary for setting up a custom Jenkins-specific DNS server
#


class jenkins-dns::server {
  package {
    'bind' :
      ensure => present,
      name   => 'bind9';

    'bind-utils' :
      ensure => present,
      name   => 'dnsutils';
  }

  file {
    '/etc/bind/jenkins-ci.org.zone' :
      ensure  => present,
      owner   => bind,
      group   => bind,
      require => Package['bind'],
      notify  => Service['bind'],
      source  => 'puppet:///modules/jenkins-dns/jenkins-ci.org.zone';

    '/etc/bind/named.conf.local' :
      ensure  => present,
      owner   => bind,
      group   => bind,
      notify  => Service['bind'],
      require => [
                  File['/etc/bind/jenkins-ci.org.zone'],
                  Package['bind']
                  ],
      source => 'puppet:///modules/jenkins-dns/named.conf.local';
  }

  service {
    'bind' :
      ensure  => running,
      require => Package['bind'],
      name  => 'bind9';
  }

  firewall {
    '900 accept tcp DNS queries' :
      proto  => 'tcp',
      port   => 53,
      action => 'accept';
    '901 accept udp DNS queries' :
      proto  => 'udp',
      port   => 53,
      action => 'accept';
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
