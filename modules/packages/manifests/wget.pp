
class packages::wget {
  package {
    'wget' :
      ensure => present;
  }
}
