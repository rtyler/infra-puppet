#
#   updates.jenkins-ci.org
#

class updates_jenkins-ci_org {
  include apache2
  include apache2::log-rotation

  file {
    "/var/www/updates.jenkins-ci.org" :
      ensure => directory,
      owner   => "www-data",
      group   => "www-data";
    "/var/www/updates.jenkins-ci.org/.htaccess" :
      ensure  => present,
      owner   => "root",
      group   => "root",
      source  => "puppet:///modules/updates_jenkins-ci_org/htaccess";
  }

  apache2::virtualhost {
    'updates.jenkins-ci.org' :
    source => 'puppet:///modules/updates_jenkins-ci_org/updates.jenkins-ci.org';
  }
}
