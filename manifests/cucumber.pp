#
#   Root manifest to be run on cucumber
#

node default {
    include base
    include haproxy
    include apache2

    class {
      'postgres' :
        version => '8.4';
    }

    package {
      'libpq-dev':
        ensure  => present,
        require => Class['postgres'];
    }

    file {
      '/srv/jekyll' :
        ensure => directory;

      '/etc/apache2/sites-available/jekyll.jenkins-ci.org' :
        ensure  => present,
        source  => 'puppet:///modules/apache2/vhost-jekyll.jenkins-ci.org';

      '/etc/apache2/sites-enabled/jekyll.jenkins-ci.org' :
        ensure  => link,
        require => File['/etc/apache2/sites-available/jekyll.jenkins-ci.org'],
        target  => '/etc/apache2/sites-available/jekyll.jenkins-ci.org';

      '/etc/php5/apache2/php.ini' :
        ensure => present,
        notify => Service['apache2'],
        source => 'puppet:///modules/apache2/php.ini';
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

      '106 accept inbound LDAPS request from hosted Artifactory by JFrog' :
        proto  => 'tcp',
        source => '50.19.229.208',
        port   => 636,
        action => 'accept';

      # It appears that puppetlabs-firewall doesn't understand an Array as an
      # option for the source argument. In fact, as far as I know, iptables can
      # only lump multiple IPs into a single rule if they're in a contiguous
      # range, this will have to do
      '106 accept inbound LDAPS request from hosted Artifactory by JFrog (second IP)' :
        proto  => 'tcp',
        source => '50.16.203.43',
        port   => 636,
        action => 'accept';


      '107 PoC experiment to reverse proxy to repo.jenkins-ci.org' :
        proto  => 'tcp',
        port   => 8082,
        action => 'accept';

      '108 Jenkins CLI port' :
        proto  => 'tcp',
        port   => 47278,
        action => 'accept';
    }
}
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
