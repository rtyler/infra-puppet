#
#   Root manifest to be run on cabbage
#

node /^cabbage$/ {
    include base
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
