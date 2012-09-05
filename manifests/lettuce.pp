#
#   Root manifest to be run on lettuce
#

node default {
    include base

    include user-kbsingh
    include user-aheritier

    include ips
    include nagios::server

    include jenkins-dns::server

    # Temporarily disable
    #include mirrorbrain

    firewall {
      '100 accept inbound HTTP requests' :
        proto  => 'tcp',
        port   => 80,
        action => 'accept';
    }
}

Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
