class mirrorbrain::cron {
    cron {
        'mirrorprobe' :
            ensure  => present,
            command => 'mirrorprobe',
            user    => root,
            minute  => 30;

        'mb scan' :
            ensure  => present,
            command => 'mb scan --quiet --jobs 4 --al',
            user    => root,
            minute  => 45;

        'mb vacuum' :
            ensure  => present,
            command => 'mb db vacuum',
            user    => root,
            minute  => 30,
            hour    => 1,
            weekday => Monday;

        'geoip-lite-update' :
            ensure  => present,
            command => 'geoip-lite-update',
            user    => root,
            minute  => 45,
            hour    => 4,
            weekday => Tuesday;
    }
}
