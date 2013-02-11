#
#   Run pkg.depotd servers for
#   mirrors.jenkins-ci.org
#
class ips {
  # this service uses Apache as a frontend
  include apache2
  Class["apache2"] -> Class["ips"]

  package {
    "ips" :
      provider => "dpkg",
      ensure => installed,
      source => "/srv/ips/ips.deb";
  }

  group {
    "ips" :
      ensure  => present;
  }

  # ips repositories run in a separate user
  user {
    "ips" :
      shell   => "/usr/bin/zsh",
      home  => "/srv/ips",
      ensure  => present,
      gid   => "ips",
      require => [
        Package["zsh"]
      ];
  }

  file {
    "/srv/ips/" :
      ensure    => directory,
      owner     => "ips",
      group     => "ips";

    "/srv/ips/.ssh" :
      ensure    => directory,
      owner     => "ips",
      group     => "ips";

    "/srv/ips/empty-repo.tgz" :
      source    => "puppet:///modules/ips/empty-repo.tgz";

    "/srv/ips/ips.deb" :
      source    => "puppet:///modules/ips/ips_2.3.54-0_all.deb";

    "/var/log/apache2/ips.jenkins-ci.org":
      ensure    => directory,
      owner     => "root",
      group     => "root";

    "/etc/apache2/sites-available/ips.jenkins-ci.org":
      ensure    => directory,
      owner     => "root",
      group     => "root",
      source    => "puppet:///modules/ips/ips.jenkins-ci.org";

    "/etc/apache2/sites-enabled/ips.jenkins-ci.org":
      notify    => Exec["reload-apache2"],
      ensure    => "../sites-available/ips.jenkins-ci.org";

    "/var/www/ips.jenkins-ci.org/":
      ensure    => "directory";

    "/var/www/ips.jenkins-ci.org/index.html":
      source    => "puppet:///modules/ips/www/index.html";

    "/var/www/ips.jenkins-ci.org/headshot.png":
      source    => "puppet:///modules/ips/www/headshot.png";
  }

  apache2::module {
    'proxy_http' : ;
  }

  ssh_authorized_key {
    "ips" :
      user    => "ips",
      ensure    => present,
      require   => File["/srv/ips/.ssh"],
      # kohsuke@griffon.2013
      key     => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCzBy1GEihAxSgrsEANgCxYwxS8Yy0U7cKq/1MMtr4/IrW2m2rzDcr4a7ZG/p/XrchCMn5eIekq1dYHsB0hY81iJr7jMZi7XbQx/LohF833YhIRctALpNzPunqBxZvOUVDib/dfX6LuoZTOojI/W5UPYrzAjyrjKMQvF5Mo0LaZ6eN1LElVaGzWExqO7mNkOrJY3IVurPu81mK4E+59FHTuB/oIawHUlxjMgBFPGKZBmb0cyVyViEmY6E78bNcN+frdSxZ72gcK/J7l1gfGz6YNQX6hKA+3v2O+/6pHf282W2hy0u4nw2DTs5NrsTnG8koiivilXC3VbhgVmQnUFKx5",
      type    => "rsa",
      name    => "kohsuke/ips";
  }

  include ips::repositories
  Class["ips"] -> Class["ips::repositories"]
}

