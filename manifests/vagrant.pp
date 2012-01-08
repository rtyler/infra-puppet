# modify this file to locally try the puppet manifest with vagrant
node /^lucid32$/ {
    include base

    #include ips
    #include user-kbsingh
    #include jenkins-dns::server
    #include nagios-server
    #include ci-ssh-slave
    #include haproxy-main
    #include mirrorbrain
}

node default {
    include base
}

Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
