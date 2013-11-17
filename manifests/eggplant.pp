#
#   Root manifest to be run on eggplant (OSUOSL VM)
#

node default {
    include base
    include atlassian
    include jira
    include confluence
    include confluence-cache

    include exim4-config::osuoslrelay
    exim4-config::dkim {'eggplant': ; }

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

    cron {
      'compress old JIRA logs' :
        # compress log files that JIRA creates on the disk
        # TODO: ideally move this to the JIRA module
        command => '/usr/local/bin/atlassian-log-compress.rb /srv/jira/current/logs',
        hour    => 1,
        minute  => 0,
        weekday => 'Monday';

      'delete old JIRA temp files' :
        # JIRA JVM creates temporary files that it doesn't always clean up on
        # its own
        command => 'find /srv/jira/current/temp/ -mtime +30 -print  | xargs rm',
        hour    => 0,
        minute  => 30;

      'compress old Confluence logs' :
        # compress log files that Confluence creates on the disk
        # TODO: ideally move this to the confluence module
        command => '/usr/local/bin/atlassian-log-compress.rb /srv/wiki/current/logs',
        hour    => 2,
        minute  => 0,
        weekday => 'Monday';

      # /srv/wiki/current/temp doesn't seem to have any interesting stuff in it
    }
}
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
