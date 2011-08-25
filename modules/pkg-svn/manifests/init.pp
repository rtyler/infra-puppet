#
#   Operating system agnostic module for handling our SVN
#   dependency
#

class pkg-svn {
    package {
        "subversion" :
            ensure  => installed;
    }
}
