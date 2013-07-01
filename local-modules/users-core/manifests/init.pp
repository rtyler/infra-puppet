#
# The users-core class contains all the users who should exist on every machine
# in the entire Jenkins cluster.
#
class users-core {
    group {
        'infraadmin' :
            ensure  => present;
    }

    include user-tyler
    include user-kohsuke
    include user-abayer
    include user-mindless
    include user-jieryn
    include user-aheritier
    include user-commands
}
