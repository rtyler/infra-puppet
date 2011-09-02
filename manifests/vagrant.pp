node default {
    $sudo_role = "standard"

    include users-core
    include sudo

    #include user-kbsingh
    #include ntpdate
    #include nagios-server
    #include ci-ssh-slave
    #include haproxy-main
    #include mirrorbrain
}
