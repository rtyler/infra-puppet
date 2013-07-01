#
# Shared part between JIRA and Confluence (and possibly other Atlassian products that we might use later)
#
class atlassian {
    file { "/usr/local/bin/atlassian-log-compress.rb":
        owner   => root,
        group   => root,
        mode    => 755,
        source  => "puppet:///modules/atlassian/atlassian-log-compress.rb"
    }
}

