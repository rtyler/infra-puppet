
class packages::vncserver {
    $tightvncserver = $operatingsystem ? {
        /(RedHat|CentOS)/   => "tightvnc-server",
        Ubuntu              => "tightvncserver",
        default             => "tightvncserver",
    }

    package {
        # on Ubuntu
        '$tightvncserver' :
            ensure => present,
            alias => "tightvncserver";
    }
}
