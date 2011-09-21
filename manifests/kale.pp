#
#   Root manifest to be run on kale
#

# Not sure what the hostname on the machine is just yet
node default {
    include base

    include ci-ssh-slave
}

Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}
