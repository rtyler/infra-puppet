
class nagios::server::packages {
  package {
    "libwww-perl" :
      ensure  => installed;

    "libcrypt-ssleay-perl" :
      ensure  => installed;

    "nagios3" :
      ensure  => installed;

    "nagios-nrpe-plugin" :
      ensure  => installed;
  }
}

# vim: shiftwidth=2 expandtab tabstop=2
