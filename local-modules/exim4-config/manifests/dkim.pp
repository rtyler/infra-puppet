#
# Configures exim4 with outbound signing of e-mails with DKIM
#

# 'name' must match the domain key selector and the portion of the key file
define exim4_config::dkim {
  include exim4_config::functions;

  file { "/etc/exim4/conf.d/main/000-dkim":
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("exim4-config/dkim.erb"),
    notify  => Exec['reload-exim4']
  }
}
