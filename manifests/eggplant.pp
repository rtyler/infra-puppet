#
#   Root manifest to be run on eggplant (OSUOSL VM)
#

node /^eggplant$/ {
    include users-core

    include ntpdate
}
