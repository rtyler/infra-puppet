#
#

class nagios::client {
    group {
      "nagios" :
          ensure  => present;
    }

    user {
        "nagios" :
            ensure  => present,
            gid     => nagios,
            shell   => "/bin/sh",
            home    => "/var/lib/nagios",
            require => [
                        Group["nagios"]
                       ];
    }

    file {
        "/var/lib/nagios" :
            ensure      => directory,
            require     => User["nagios"],
            owner       => "nagios",
            group       => "nagios";
        "/var/lib/nagios/.ssh" :
            ensure      => directory,
            require     => File["/var/lib/nagios"],
            owner       => "nagios",
            group       => "nagios";
    }

    ssh_authorized_key {
        "nagios" :
                user    => "nagios",
                ensure  => "present",
                require => File["/var/lib/nagios/.ssh"],
                key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAs2ST7fNG1/UDkt8YhvgMa8DFiHPooyjQ3vxDE0Pt1HRJN4qwAS5mNTlEGvJnAJS243BTqhzmIE/UeC76vEvWzJazQt9fmPpjKYhsm0BQfG/oxkOcLWRNxrfw9GgwEiVw68qqJl6vfCmlwJseIiJQJX5kbC99HURsG0+7Vo3eyQt2BP7kgFQrH7o5hvF+ca0MPt2YVPn4Btm20PpZ5o8BR/KjFkzsORSs52wvzp4pJMDpEnIyCa2g4HQ57ucDQtluuIaV01lrzaMohhg2ZORIoUrHX2mBbR2Id1PCA84f9EE4Rqia3G2cdYM62ewqgxUQyTqXhgWDQ1X51DEJgvU1jw==",
                type    => "rsa",
                name    => "nagios@${hostname}";
    }

    package {
        "nagios-plugins-extra" :
            ensure  => installed;
    }
}
# vim: shiftwidth=4 expandtab tabstop=4
