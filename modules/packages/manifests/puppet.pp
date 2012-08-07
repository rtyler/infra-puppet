class packages::puppet {
  package {
    'facter' :
      ensure   => '1.6.10',
      provider => gem,
      require  => Class['packages::ruby'];

    'puppet' :
      ensure   => '2.7.18',
      provider => gem,
      require  => [Package['facter'], Class['packages::ruby']];
  }
}
