#
#   Root manifest to be run on cabbage
#

node default {
  include base

  include confluence
  include host-git-repositories

  firewall {
    '100 accept inbound HTTP requests' :
    proto  => 'tcp',
    port   => 80,
    action => 'accept';

    '101 accept inbound HTTPs requests' :
    proto  => 'tcp',
    port   => 443,
    action => 'accept';
  }
}

Exec {
  path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
