#
#   Jenkins infrastructure base module
#
#   The base class should include everything that's necessary as a foundation
#   for a Jenkins infrastructure machine. If there is any reason a class should
#   not be loaded on every machine, then it should go elsewhere

class base {
    include autoupdate
    include jenkins-dns
    include nagios-client
    include ntpdate
    include sudo
    include users-core


    stage {
        "pre" :
            before => Stage["main"];
        "post" :
            require => Stage["main"];
    }

    package {
        "git-core" :
            ensure => present;
        # htop(1) is generally handy, and I like having it around :)
        "htop" :
            ensure => present;
    }

    group {
        'puppet' :
            ensure => present,
    }

    class {
        'base::pre' :
            stage => 'pre';
        'base::post' :
            stage => 'post';
    }

    firewall {
        '000 accept all icmp requests' :
            proto  => 'icmp',
            action => 'accept';

        '001 accept inbound ssh requests' :
            proto  => 'tcp',
            port   => 22,
            action => 'accept';

        '002 accept local traffic' :
            # traffic within localhost is OK
            iniface => 'lo',
            action => 'accept';

        '003 allow established connections':
            # this is needed to make outbound connections work, such as database connection
            state => ['RELATED','ESTABLISHED'],
            action => 'accept';

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

class base::post {
    firewall {
        '999 drop all other requests':
            action => 'drop';
    }
}
# vim: shiftwidth=4 expandtab tabstop=4
