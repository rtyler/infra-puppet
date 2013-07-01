#
#   haproxy module for managing the main haproxy installation (currently
#   running on cucumber)
#

class haproxy {

  package {
    'haproxy' :
      ensure => installed;
  }

  file {
    '/etc/haproxy' :
      ensure  => directory,
      owner   => 'haproxy',
      group   => 'haproxy',
      require => Package['haproxy'];

    '/etc/default/haproxy' :
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      require => Package['haproxy'],
      notify  => Service['haproxy'],
      source  => 'puppet:///modules/haproxy/haproxy-defaults';

    '/etc/haproxy/haproxy.cfg' :
      ensure  => present,
      owner   => 'haproxy',
      group   => 'haproxy',
      notify  => Service['haproxy'],
      require => File['/etc/haproxy'],
      source  => 'puppet:///modules/haproxy/haproxy.cfg';
  }

  service {
    'haproxy' :
      ensure     => running,
      enable     => true,
      require    => Package['haproxy'],
      hasstatus  => true,
      hasrestart => true;
  }
}
