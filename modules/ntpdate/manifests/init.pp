#
#   Set up a simple ntpdate cron for all hosts to prevent clock skew
#
#   This will run ntpdate and hit pool.ntp.org every morning at 4:15 am local
#   time. Our clocks shouldn't be skewing too much in a 24 hour period
#

class ntpdate {

    $ntpdate = $operatingsystem ? {
                "CentOS"    => ntp,
                default     => ntpdate
    }

    package {
        $ntpdate :
            alias   => ntpdate,
            ensure  => installed;
    }


    cron {
        ntpdate :
            command => "/usr/sbin/ntpdate pool.ntp.org",
            user    => root,
            minute  => 15,
            hour    => 4,
            ensure  => present,
            require => Package[$ntpdate];
    }

}
