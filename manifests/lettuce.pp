#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    include base

    include user-kbsingh
    include user-aheritier

    include ips
    include nagios-server

    include jenkins-dns::server

    # Temporarily disable
    #include mirrorbrain
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
