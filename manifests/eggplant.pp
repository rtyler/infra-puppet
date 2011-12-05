#
#   Root manifest to be run on eggplant (OSUOSL VM)
#

node /^eggplant$/ {
    include base
}
Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
