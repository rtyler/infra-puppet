#
# Hosts read-only Git repositories and expose it via Apache
#
class git-repositories {
  include apache2
  include apache2::log-rotation

  $gitrepo_dir="/var/www/git.jenkins-ci.org"

  file {
    $gitrepo_dir :
      ensure  => directory,
      owner   => 'www-data',
      group   => 'www-data',
      require => Class['apache2'];
  }

  git::repository {
    "all" :
      description => "Hi";
  }

  package {
    "gitweb" :
      ensure    => installed;
  }

  file {
    "/etc/gitweb.conf":
      source => 'puppet:///modules/git-repositories/gitweb.conf';
  }

  apache2::virtualhost {
    'git.jenkins-ci.org' :
        require => Class['apache2'],
        source    => 'puppet:///modules/git-repositories/git.jenkins-ci.org';
  }
}

# create one Git repository
define git::repository($description) {
  $gitrepo_dir=$git-repositories::gitrepo_dir

  exec {
    "create repository ${name}" :
      require => File[$gitrepo_dir],
      unless  => "test -d ${gitrepo_dir}/${name}.git",
      path  => ['/bin', '/usr/bin'],
      user  => 'www-data',
      command => "git init --bare ${gitrepo_dir}/${name}.git";
  }

  file {
    "${gitrepo_dir}/${name}.git/description":
      require => Exec["create repository ${name}"],
      content => $description;
  }
}

# vim: shiftwidth=2 expandtab tabstop=2
