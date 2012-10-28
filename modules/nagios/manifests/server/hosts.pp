#####
# The purpose of this class is kind of a hack due to the nature of exported
# resources with our distributed/masterless set up. We *could* try to use
# exported resources, but we'd need a centralized datastore somewhere between
# the OSUOSL, Contegix and Rackspace to make it work. On top of that all the
# other hosts would need to be able to write into it.
#
# Instead, we'll just enumerate what checks we want here.
class nagios::server::hosts {
  include nagios::server

  nagios::server::basic-host {
    "lettuce" :
      full_name => "lettuce.jenkins-ci.org";
    "cabbage" :
      ensure    => absent,
      full_name => "cabbage.jenkins-ci.org";
    "spinach" :
      full_name => "spinach.jenkins-ci.org";
    "cucumber" :
      full_name => "cucumber.jenkins-ci.org";
    "eggplant" :
      full_name => "eggplant.jenkins-ci.org";
    'kale' :
      os        => 'redhat',
      full_name => 'kale.jenkins-ci.org';
    }
}

# vim: shiftwidth=2 expandtab tabstop=2
