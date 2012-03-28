
class packages::ruby {
  package {
    'rubygems' :
      ensure => present;
    'ruby1.8-dev' :
      ensure => present;
  }
}
