#
#   Root manifest to be run on cabbage
#

node /^cabbage$/ {
    $sudo_role = "standard"

    include base
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
