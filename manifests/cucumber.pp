#
#   Root manifest to be run on cucumber
#

node /^cucumber$/ {
    include users-core

    include ntpdate

    include haproxy-main
}
