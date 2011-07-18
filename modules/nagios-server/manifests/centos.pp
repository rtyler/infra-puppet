class nagios-server::centos {
    package {
        "perl-libwww-perl" :
            alias   => perl-libwww,
            ensure  => installed;

        "perl-Crypt-SSLeay" :
            alias   => perl-crypt-ssleay,
            ensure  => installed;

        "nagios" :
            alias   => nagios,
            ensure  => installed;

        "nagios-plugins-all" :
            alias   => nagios-plugins,
            ensure  => installed;

        "nrpe" :
            alias   => nagios-nrpe,
            ensure  => installed;
    }

}
