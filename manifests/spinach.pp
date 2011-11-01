#
#   Root manifest to be run on spinach (Rackspace-donated build machine)
#

# Not explicitly specifying a regex to match to spinach.jenkins-ci.org since
# the machine is configured with a hostname of "jenkins-01" for some goofy
# reason

node default {
    include base
    include user-jieryn
    include ci-ssh-slave
}
