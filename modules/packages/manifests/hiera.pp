class packages::hiera {
  package {
    'hiera' :
      ensure   => present,
      require  => Package['rubygems'],
      provider => 'gem';

    'hiera-gpg' :
      ensure   => present,
      require  => [
                  Package['rubygems'],
                  Package['gnupg'],
      ],
      provider => 'gem';

    'gnupg' :
      ensure  => present;
  }
}
