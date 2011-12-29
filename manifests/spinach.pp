#
#   Root manifest to be run on spinach (Rackspace-donated build machine)
#

node /^spinach$/ {
    include base
    include user-jieryn
    include ci-ssh-slave
}

Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
