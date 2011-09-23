class nagios-server::ubuntu {
    include apache2
    include nagios-server::ubuntu::packages
    include nagios-server::ubuntu::install

    Class["apache2"] ->
        Class["nagios-server::ubuntu::packages"] ->
            Class["nagios-server::ubuntu::install"]
}


class nagios-server::ubuntu::packages {
    package {
        "libwww-perl" :
            ensure  => installed;

        "libcrypt-ssleay-perl" :
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

class nagios-server::ubuntu::install {
    service {
        "nagios3" :
            ensure => running,
            enable => true,
            require => Package["nagios"];
    }
}
