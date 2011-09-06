#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    $sudo_role = "standard"

    include users-core
    include user-kbsingh
    include user-aheritier

    include sudo

    include ntpdate

    # Temporarily disable
    #include mirrorbrain
}
