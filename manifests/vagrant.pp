node default {
    include users-core

    #include user-kbsingh
    #include ntpdate
    #include nagios-server
    #include ci-ssh-slave
    #include haproxy-main

    include mirrorbrain
}
