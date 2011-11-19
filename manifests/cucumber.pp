#
#   Root manifest to be run on cucumber
#

node /^cucumber$/ {
    include base
}
Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
