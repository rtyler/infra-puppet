#
# Configures exim4 with outbound signing of e-mails with DKIM
#

# 'name' must match the domain key selector and the portion of the key file
define exim4-config::dkim {
  include exim4-config::functions

  file { "/etc/exim4/conf.d/main/000-dkim":
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("exim4-config/dkim.erb"),
    require => Package['exim4'],
    notify  => Exec['reload-exim4']
  }
}
