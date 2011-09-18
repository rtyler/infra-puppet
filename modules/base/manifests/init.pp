#
#   Jenkins infrastructure base module
#
#   The base class should include everything that's necessary as a foundation
#   for a Jenkins infrastructure machine. If there is any reason a class should
#   not be loaded on every machine, then it should go elsewhere

class base {
    # Every single machine should have users-core and ntpdate
    include users-core
    include sudo

    include ntpdate
    include autoupdate

    stage {"pre": before => Stage["main"]}

    package {
        "git-core" :
            ensure => present,
    }

    group {
        "puppet" :
            ensure => present,
    }

    class {
        "base::pre" :
            stage => "pre";
    }
}

class base::pre {
    # It's generally useful to make sure our package meta-data is always up to
    # date prior to running just about everything else
    exec {
        "apt-get update" :
            command => "apt-get update",
    }
}
