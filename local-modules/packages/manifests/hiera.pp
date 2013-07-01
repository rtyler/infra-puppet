class packages::hiera {
  package {
    'hiera' :
      ensure   => absent,
      require  => Package['rubygems'],
      provider => 'gem';

    'hiera-gpg' :
      ensure   => absent,
      require  => [
                  Package['rubygems'],
                  Package['gnupg'],
      ],
      provider => 'gem';

    'gnupg' :
      ensure  => present;
  }
}
