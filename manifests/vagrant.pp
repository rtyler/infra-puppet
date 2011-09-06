node /^lucid32$/ {
    $sudo_role = "standard"

    include base

    include autoupdate

    #include user-kbsingh
    #include nagios-server
    #include ci-ssh-slave
    #include haproxy-main
    #include mirrorbrain
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
