#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    include base

    include user-kbsingh
    include user-aheritier


    # Temporarily disable
    #include mirrorbrain
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
