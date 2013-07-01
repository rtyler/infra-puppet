
class packages::ruby {
  package {
    'ruby' :
      ensure => present;
    'rubygems' :
      ensure => present;
    'ruby1.8-dev' :
      ensure => present;
    'make' :
      ensure => present;
  }
}
