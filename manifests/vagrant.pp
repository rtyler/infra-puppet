node default {
    include users-core
    include user-kbsingh

    include ntpdate

    include nagios-server

    include haproxy-main

    include ci-ssh-slave

    include mirrorbrain
}
