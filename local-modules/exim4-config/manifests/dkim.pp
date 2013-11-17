#
# Configures exim4 with outbound signing of e-mails with DKIM
#
# once the key is generated, it has to be added to jenkins-ci.org.zone file
#
# 'name' must match the domain key selector and the portion of the key file
define exim4-config::dkim {
  include exim4-config::functions

  exec {
  "generate-dkim-key":
    creates => "/etc/exim4/dkim-$name.key",
    cwd     => "/etc/exim4",
    command => "openssl genrsa -out dkim-$name.key 2048    \
                && chgrp Debian-exim dkim-$name.key    \
                && chmod 640 dkim-$name.key    \
                && openssl rsa -in dkim-$name.key -out dkim-$name.pub -pubout -outform PEM",
    notify  => Exec['reload-exim4']
  }

  file { "/etc/exim4/conf.d/main/000-dkim":
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("exim4-config/dkim.erb"),
    require => Package['exim4'],
    notify  => Exec['reload-exim4']
  }
}
