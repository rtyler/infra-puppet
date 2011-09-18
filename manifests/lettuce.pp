#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    include base

    include user-kbsingh
    include user-aheritier

    include ips

    # Temporarily disable
    #include mirrorbrain
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
