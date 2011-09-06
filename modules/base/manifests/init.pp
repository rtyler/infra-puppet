#
#   Jenkins infrastructure base module
#
#   The base class should include everything that's necessary as a foundation
#   for a Jenkins infrastructure machine. If there is any reason a class should
#   not be loaded on every machine, then it should go elsewhere

class base {
    # Set a global exec path, to avoid retyping all of this madness
    Exec {
        path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
    }

    # Every single machine should have users-core and ntpdate
    include users-core
    include sudo

    include ntpdate
}
