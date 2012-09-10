#
# Ensure consistent denyhosts settings across all machines
#

class base::denyhosts {
  file {
    '/var/lib/denyhosts' :
      ensure => directory;

    '/var/lib/denyhosts/allowed-hosts' :
      ensure  => present,
      require => File['/var/lib/denyhosts'],
      content => "140.211.15.121";
  }
}
