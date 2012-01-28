
class packages::ruby {
  package {
    'rubygems' :
      ensure => present;
  }
}
