
class mirrorbrain::files {
    file {
        '/etc/apache2/sites-available/mirrors.jenkins-ci.org' :
            ensure  => present,
            require => Class['apache2'],
            source  => 'puppet:///modules/mirrorbrain/virtualhost.conf';

        '/etc/apache2/mods-available/geoip.conf' :
            ensure  => present,
            require => [
                        Class['apache2']
                       ],
            source  => 'puppet:///modules/mirrorbrain/geoip.conf';

        '/etc/apache2/mods-available/dbd.conf' :
            ensure  => present,
            require => Class['apache2'],
            source  => [
                        'puppet:///modules/mirrorbrain/dbd.conf.private',
                        'puppet:///modules/mirrorbrain/dbd.conf'];


        '/etc/mirmon.conf' :
            ensure  => present,
            source  => 'puppet:///modules/mirrorbrain/mirmon.conf';

        '/etc/mirrorbrain.conf' :
            ensure  => present,
            source  => 'puppet:///modules/mirrorbrain/mirrorbrain.conf';
    }

    enable-apache-site {
        'mirrors.jenkins-ci.org' :
            name    => 'mirrors.jenkins-ci.org',
            require => File['/etc/apache2/sites-available/mirrors.jenkins-ci.org'];
    }
}
# vim: shiftwidth=2 expandtab tabstop=2
