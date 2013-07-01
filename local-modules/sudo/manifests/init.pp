#
#
#
class sudo($sudo_role='standard'){
  package {
    'sudo' :
      ensure => latest,
  }

  file {
    '/etc/sudoers':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0440',
      source  => "puppet:///modules/sudo/${sudo_role}-sudoers",
      require => Package['sudo'];
  }
}
# vim: shiftwidth=2 expandtab tabstop=2
