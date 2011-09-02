#
#   Root manifest to be run on cabbage
#

node /^cabbage$/ {
    include users-core

    include ntpdate
}
