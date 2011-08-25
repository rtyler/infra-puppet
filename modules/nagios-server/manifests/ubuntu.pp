class nagios-server::ubuntu {
    package {
        "apache2" :
            alias   => apache2,
            ensure  => installed;

        "libwww-perl" :
            alias   => perl-libwww,
            ensure  => installed;

        "libcrypt-ssleay-perl" :
            alias   => perl-crypt-ssleay,
            ensure  => installed;

        "nagios3" :
            alias   => nagios,
            ensure  => installed;

        "nagios-plugins-extra" :
            alias   => nagios-plugins,
            ensure  => installed;

        "nagios-nrpe-plugin" :
            alias   => nagios-nrpe,
            ensure  => installed;
    }
}
