#####
# The purpose of this class is kind of a hack due to the nature of exported
# resources with our distributed/masterless set up. We *could* try to use
# exported resources, but we'd need a centralized datastore somewhere between
# the OSUOSL, Contegix and Rackspace to make it work. On top of that all the
# other hosts would need to be able to write into it.
#
# Instead, we'll just enumerate what checks we want here.
class nagios-server::clients {
    include nagios-server::defines

    basic-nagios-host {
        "lettuce" :
            name      => "lettuce",
            full_name => "lettuce.jenkins-ci.org";
        "cabbage" :
            name      => "cabbage",
            full_name => "cabbage.jenkins-ci.org";
        "spinach" :
            name      => "spinach",
            full_name => "spinach.jenkins-ci.org";
        "cucumber" :
            name      => "cucumber",
            full_name => "cucumber.jenkins-ci.org";
        "eggplant" :
            name      => "eggplant",
            full_name => "eggplant.jenkins-ci.org";
    }
}
# vim: shiftwidth=4 expandtab tabstop=4
