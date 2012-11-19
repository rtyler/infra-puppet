#
# Hosts read-only Git repositories and expose it via Apache
#
class gitrepo {
  include apache2
  include apache2::log-rotation

  $gitrepo_dir="/var/www/git.jenkins-ci.org"

  package {
    "gitweb" :
      ensure    => installed;
  }

  file {
    "/etc/gitweb.conf":
      source => 'puppet:///modules/gitrepo/gitweb.conf';

    "/var/www/git.jenkins-ci.org/indextext.html":
      source => 'puppet:///modules/gitrepo/indextext.html';
  }

  apache2::virtualhost {
    'git.jenkins-ci.org' :
        require => Class['apache2'],
        source    => 'puppet:///modules/gitrepo/git.jenkins-ci.org';
  }
}
