#
#   Operating system agnostic module for handling our SVN
#   dependency
#

class packages::subversion {
    package {
        "subversion" :
            ensure  => installed;
    }
}
