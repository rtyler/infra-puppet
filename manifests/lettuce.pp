#
#   Root manifest to be run on lettuce
#

node /^lettuce$/ {
    include users-core
    include user-kbsingh

    include ntpdate
}
