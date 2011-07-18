# Jenkins CI Puppet Repository


### About

In order to more effectively manage the [Jenkins
project](http://www.jenkins-ci.org)'s infrastructure these manifests have been
created. There a couple of reasons for this:

 * **Reproducibility**: In the unfortunate scenario where a meteor falls on a
   datacenter where Jenkins hardware exists, we want to be able to bring a new
   host on to fulfill those needs as soon as possible.
 * **Distributable**: With [Puppet](http://puppetlabs.org/puppet/) manifests
   stored in this repository, it is easier to accept infrastructure help from
   members of the Jenkins community, without necessarily giving root access
   out.
 * **Accountability**: By funneling as much infrastructure work through Puppet
   as possible, we can have ensure the project has a very clear audit trail for
   specific infrastructure changes.


### Getting Started

We use [Vagrant](http://vagrantup.com) to develop and test these manifests and
as such there is a `Vagrantfile` already in the root directory. If you don't
already have Vagrant:

    % sudo gem install vagrant

Once you have vagrant you should be able to execute the following command to
bring up a test virtual machine and provision it:

    % vagrant up

For development, you can just create your manifests and include them in
`manifests/vagrant.pp`, once you're ready to re-run the puppet manifests you
can run the following command (no need to rebuild the VM):

    % vagrant provision


### Getting Help

If you have any questions, stop by the `#jenkins` channel on the
[Freenode](http://freenode.net) network and ask
[rtyler](http://github.com/rtyler/).

Failing that, the `jenkinsci-users@` mailing list is a good place to ask for
help.

