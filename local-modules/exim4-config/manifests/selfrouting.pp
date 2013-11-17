#
# Configures exim4 to deliver messages on its own (instead of just passing it on to smarthost)
#
#

class exim4_config::selfrouting {
    file { "/etc/exim4/update-exim4.conf.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/exim4-config/selfrouting/update-exim4.conf.conf"
    }
}
