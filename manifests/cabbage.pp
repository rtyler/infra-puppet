#
#   Root manifest to be run on cabbage
#

node default {
  include base

  #include confluence
  include gitrepo
  include groovy  # promote this into base when ready

  gitrepo::repo {
    'all' :
      description => 'One repository that contains all Jenkins CI github repositories. "git clone http://git.jenkins-ci.org/all.git" to clone this repository.';
  }

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
