class mirrorbrain::cron {
    cron {
        "mirrorprobe" :
            command => "mirrorprobe",
            user    => root,
            minute  => 30,
            ensure  => present;

        "mb scan" :
            command => "mb scan --quiet --jobs 4 --al",
            user    => root,
            minute  => 45,
            ensure  => present;

        "mb vacuum" :
            command => "mb db vacuum",
            user    => root,
            minute  => 30,
            hour    => 1,
            weekday => Monday,
            ensure  => present;

        "geoip-lite-update" :
            command => "geoip-lite-update",
            user    => root,
            minute  => 45,
            hour    => 4,
            weekday => Tuesday,
            ensure  => present;
    }
}
