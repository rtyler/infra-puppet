#
#   A theoretically operating system agnostic module for handling our Git
#   dependency
#

class pkg-git {
    if $operatingsystem == "CentOS" {
        include  pkg-git::centos
    }
    else {
        include  pkg-git::ubuntu
    }
}
