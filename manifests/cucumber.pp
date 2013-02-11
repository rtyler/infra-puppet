#
#   Root manifest to be run on cucumber
#
node default {
    include base
    include haproxy
    include apache2
    include updates_jenkins-ci_org

    class {
      'postgres' :
        version => '8.4';
    }

    cron {
      "time sync" :
        command => '/usr/sbin/ntpdate pool.ntp.org',
        minute  => 15;

      'ping the mirrors' :
        command => '/usr/bin/mirrorprobe',
        minute  => 30;

      'scan the mirrors' :
        command => '/usr/bin/mb scan --quiet --jobs 2 --all',
        minute  => '*/30';

      'cleanup the mirror db' :
        command => '/usr/bin/mb db vacuum',
        hour    => 1,
        minute  => 30,
        weekday => 'Monday';

      'update the Geo IP database' :
        command => '/usr/bin/geoip-lite-update',
        hour    => 4,
        minute  => 50,
        weekday => 'Monday';

      'update the time for mirror sync checks' :
        command => '/root/update_mirror_time.sh',
        minute  => 0;

      'update mirmon status page' :
        command => '/usr/bin/mirmon -q -get update -c /etc/mirmon.conf',
        minute  => 45;

      'copy wiki logs from eggplant to save space' :
        command => 'cd /var/log/apache2/wiki.jenkins-ci.org && ./pull.sh',
        minute  => 5;

      'copy jira logs from eggplant to save space' :
        command => 'cd /var/log/apache2/issues.jenkins-ci.org && ./pull.sh',
        minute  => 10;
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

      # normally nobody listens on this port, but when we need to find the source IP address
      # JFrog is using to connect us, run 'stone -d -d localhost:636 9636' and watch the log
      '106 debugging the LDAPS connection (necessary to report source IP address)' :
        proto  => 'tcp',
        port   => 9636,
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
