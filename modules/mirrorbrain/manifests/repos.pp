class mirrorbrain::repos {
    file {
        '/etc/apt/sources.list.d' :
            ensure => directory;

        '/etc/apt/sources.list.d/mirrorbrain.list' :
            ensure => present,
            notify => [
                        Exec['install-key'],
                        Exec['refresh-apt']],
            source => 'puppet:///modules/mirrorbrain/apt.list',
    }

    file {
        '/root/mirrorbrain.key' :
            ensure => present,
            source => 'puppet:///modules/mirrorbrain/Release.key';
    }

    exec {
        'refresh-apt' :
            refreshonly => true,
            require     => [
                        File['/etc/apt/sources.list.d/mirrorbrain.list'],
                        Exec['install-key']],
            command     => 'apt-get update';

        'install-key' :
            notify  => Exec['refresh-apt'],
            require => [
                        File['/etc/apt/sources.list.d/mirrorbrain.list'],
                        File['/root/mirrorbrain.key']],
            unless  => '/usr/bin/apt-key list | grep "BD6D129A"',
            command => '/usr/bin/apt-key add /root/mirrorbrain.key';
    }
}
# vim: shiftwidth=2 expandtab tabstop=2
