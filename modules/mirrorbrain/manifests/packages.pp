class mirrorbrain::packages {
    package {
        'libapache2-mod-geoip' :
            ensure  => installed,
            require => Package['apache2'];

        'libapache2-mod-mirrorbrain' :
            ensure  => installed,
            require => Package['apache2'];

        'mirrorbrain' :
            ensure => installed;

        'mirrorbrain-scanner' :
            ensure => installed;

        'mirrorbrain-tools' :
            ensure => installed;

        'postgresql-server-dev-8.4' :
            ensure => installed;

        'mirmon' :
            ensure => installed;

        # Python dependencies
        ######################################
        # Needed to build the stupid mb tools
        'python-dev' :
            ensure => installed;

        'python-psycopg2' :
            ensure  => installed,
            require => Package['postgresql-server-dev-8.4'];
        'python-sqlobject' :
            ensure => installed;
        'python-cmdln' :
            ensure => installed;
    }
}

# vim: shiftwidth=2 expandtab tabstop=2
