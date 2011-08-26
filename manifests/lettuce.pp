#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    include users-core
    include user-kbsingh
    include user-aheriter

    include ntpdate
    # Temporarily disable
    #include mirrorbrain
}
