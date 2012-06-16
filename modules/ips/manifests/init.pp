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
      key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEArSave9EBJ2rP3Hm5PFyiOpfGsPhJwjqdyaVEwQruM0Fa8nWstla7cdSTSs/ClHn7I1uUzQvX+/+6m/HTVy/WIr0cIIxLDm8hXVLfCLddtvxnXx47fJY3ongasYJ4TarIGkMMX/Vg1JpP7XIkMczUSNRyeHg/bGfV+YCPFuSW+cj2M5yMOE1KyIVQQL/JZu7lu80Ara5+RWSITObdiHRpnNzvBdIyhkSCrG0N7QStIBnEaLU//K2AB5GbK/65+k7sklutcH18wSGridQCNJm4ODUxov+vVr2OH3oiv7gyHEE9TypRI9vS0HUmsD+moPq3O8y0xyP8xaJWkz2LKe8/5Q==",
      type    => "rsa",
      name    => "kohsuke@unicorn.2010/ips";
  }

  include ips::repositories
  Class["ips"] -> Class["ips::repositories"]
}

