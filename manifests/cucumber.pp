#
#   Root manifest to be run on cucumber
#

node /^cucumber$/ {
    include base
    include haproxy

    firewall {
      '100 accept inbound HTTP requests' :
        proto  => 'tcp',
        port   => 80,
        action => 'accept';

      '101 accept inbound HTTPs requests' :
        proto  => 'tcp',
        port   => 443,
        action => 'accept';

      '102 accept inbound rsync requests' :
        proto  => 'tcp',
        port   => 873,
        action => 'accept';

      '103 accept inbound Subversion requests' :
        proto  => 'tcp',
        port   => 3690,
        action => 'accept';

      '104 accept inbound requests to Nexus' :
        proto  => 'tcp',
        port   => 8081,
        action => 'accept';

      '105 accept all requests from eggplant' :
        proto  => 'tcp',
        source => 'hudson-java.osuosl.org',
        action => 'accept';
    }
}
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
