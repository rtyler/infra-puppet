#
#   Manifest responsible for driving a the MirrorBrain installation behind
#   mirrors.jenkins-ci.org

class mirrorbrain {
    include pkg-apache2

    # I think it's safe to assume that if we're not on CentOS, we're running on
    # Ubuntu
    if $operatingsystem == "CentOS" {
        include  mirrorbrain::centos
    }
    else {
        err("MirrorBrain is currently only configured for CentOS hosts")
    }

    Class["pkg-apache2"] -> Class["mirrorbrain::centos"]
}

class mirrorbrain::centos {

    yumrepo {
        "MirrorBrain" :
            baseurl => "http://download.opensuse.org/repositories/Apache:/MirrorBrain/CentOS_5/",
            descr => "MirrorBrain OBS repo",
            enabled => 1,
            gpgcheck => 0
    }
}
