#
#   Jenkins infrastructure base module
#
#   The base class should include everything that's necessary as a foundation
#   for a Jenkins infrastructure machine. If there is any reason a class should
#   not be loaded on every machine, then it should go elsewhere

class base {
  # Unfortunately this module only supports Ubuntu
  if ($operatingsystem == 'Ubuntu') {
    include nagios::client
  }


  stage {
    'pre' :
      before => Stage['main'];
    'post' :
      require => Stage['main'];
  }

  class {
    'base::pre' :
      stage => 'pre';

    'base::post' :
      stage => 'post';

    'puppet' :
      ensure => '2.7.19-1puppetlabs2';

    ['autoupdate',
     'base::denyhosts',
     'jenkins-dns',
     'sshd',
     'sudo',
     'stdlib',
     'users-core',
     'packages::git',
     'packages::wget',
     'packages::hiera',
     'packages::ruby'] : ;

    'ntp' :
      servers  => ['pool.ntp.org iburst'],
      autoupdate => true;
  }

  file {
    '/etc/puppet' :
      ensure => directory,
      owner  => root,
      group  => root;

    '/etc/puppet/hiera' :
      ensure  => directory,
      owner   => root,
      group   => root,
      require => [
            File['/etc/puppet'],
            Class['packages::hiera'],
      ];
  }


  package {
    # htop(1) is generally handy, and I like having it around :)
    'htop' :
      ensure => present;
    # fakeroot is handy for building .deb packages
    'fakeroot' :
      ensure => present;
    # Can't live without tmux anymore :)
    'tmux' :
      ensure => present;
  }

  group {
    'puppet' :
      ensure => present,
  }

  sshd::config {
    'PermitRootLogin' :
      value => 'no';

    'PasswordAuthentication' :
      value => 'no';

    'UseDNS' :
      value => 'no';
  }

  cron {
    'clean the repo-update cache' :
      command => 'rm -f /tmp/repos-updated',
      hour    => 0;
  }

  firewall {
    '000 accept all icmp requests' :
      proto  => 'icmp',
      action => 'accept';

    '001 accept inbound ssh requests' :
      proto  => 'tcp',
      port   => 22,
      action => 'accept';

    '002 accept local traffic' :
      # traffic within localhost is OK
      iniface => 'lo',
      action => 'accept';

    '003 allow established connections':
      # this is needed to make outbound connections work, such as database connection
      state => ['RELATED','ESTABLISHED'],
      action => 'accept';

  }
}

class base::pre {
  # It's generally useful to make sure our package meta-data is always up to
  # date prior to running just about everything else
  if ($operatingsystem == 'Ubuntu') {
    # hack until we upgrade to supported versions of Ubuntu
    $command = 'apt-get update ; touch /tmp/repos-updated'
  }
  elsif ($operatingsystem =~ /(RedHat|CentOS)/) {
    $command = 'yum makecache && touch /tmp/repos-updated'
  }
  else {
    err('Unsupported platform!')
  }

  exec {
    'pre-update packages' :
      command => $command,
      unless  => 'test -f /tmp/repos-updated';
  }
}

class base::post {
  firewall {
    '999 drop all other requests':
      action => 'drop';
  }

  exec {
    'kill puppet gems' :
      onlyif  => 'gem list | grep ^puppet',
      command => 'gem uninstall -ax puppet facter',
      path    => ['/var/lib/gems/1.8/bin', '/usr/local/bin', '/usr/bin', '/bin'];
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
