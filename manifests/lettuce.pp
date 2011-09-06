#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    $sudo_role = "standard"

    include base

    include user-kbsingh
    include user-aheritier


    # Temporarily disable
    #include mirrorbrain
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
