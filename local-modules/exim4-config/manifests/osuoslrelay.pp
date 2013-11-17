#
# Configures exim4 to deliver messages via OSUOSL relay
#
#

class exim4-config::osuoslrelay {
  include exim4-config::functions

  file { "/etc/exim4/update-exim4.conf.conf":
    owner   => root,
    group   => root,
    mode    => 644,
    source  => "puppet:///modules/exim4-config/osuoslrelay/update-exim4.conf.conf",
    notify  => Exec['reload-exim4']
  }
}
