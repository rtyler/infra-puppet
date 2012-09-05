#
#   Root manifest to be run on eggplant (OSUOSL VM)
#

node default {
    include base

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
      "compress old JIRA logs" :
        # compress log files that JIRA creates on the disk
        # TODO: ideally move this to the JIRA module
        command => 'find /srv/jira/current/logs -mtime +30 -and -type f -print | grep -v \'.gz$\' | xargs gzip',
        hour    => 1,
        minute  => 0,
        weekday => 'Monday';

      "delete old JIRA temp files" :
        # JIRA JVM creates temporary files that it doesn't always clean up on its own
        command => 'find /srv/jira/current/temp/ -mtime +30 -print  | xargs rm',
        hour    => 0,
        minute  => 30;

      "compress old Confluence logs" :
        # compress log files that Confluence creates on the disk
        # TODO: ideally move this to the confluence module
        command => 'find /srv/wiki/current/logs -mtime +30 -and -type f -print | grep -v \'.gz$\' | xargs gzip',
        hour    => 2,
        minute  => 0,
        weekday => 'Monday';

      # /srv/wiki/current/temp doesn't seem to have any interesting stuff in it
    }
}
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
