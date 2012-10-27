
class packages::vncserver {
  package {
    # on Ubuntu
    'tightvncserver' :
      ensure => present;
  }
}
