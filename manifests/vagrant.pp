node /^lucid32$/ {
    include base

    #include user-kbsingh
    #include nagios-server
    #include ci-ssh-slave
    #include haproxy-main
    #include mirrorbrain
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
