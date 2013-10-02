#
#   updates.jenkins-ci.org
#

class updates_jenkins-ci_org {
  include apache2
  include apache2::log-rotation

  file {
    "/var/www/updates.jenkins-ci.org/readme.html" :
      ensure  => present,
      owner   => "root",
      group   => "root",
      source  => "puppet:///modules/updates_jenkins-ci_org/readme.html";
    "/var/www/updates.jenkins-ci.org/.htaccess" :
      ensure  => present,
      owner   => "root",
      group   => "root",
      source  => "puppet:///modules/updates_jenkins-ci_org/htaccess";
  }

  apache2::virtualhost {
    'updates.jenkins-ci.org' :
    source => 'puppet:///modules/updates_jenkins-ci_org/site.conf';
  }
}
