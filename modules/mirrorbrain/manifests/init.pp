#
#   Manifest responsible for driving a the MirrorBrain installation behind
#   mirrors.jenkins-ci.org

class mirrorbrain {
    if $operatingsystem != 'Ubuntu' {
        err('The mirrorbrain module is currently only functional for Ubuntu hosts')
    }

    include mirrorbrain::ubuntu
    include apache2
    Class['apache2'] -> Class['mirrorbrain::ubuntu']
}
# vim: shiftwidth=2 expandtab tabstop=2
