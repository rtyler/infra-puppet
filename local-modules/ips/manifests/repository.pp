define ips::repository($name,$port) {
  include apache2
  include apache2::functions
  # empty place holder for the repository
  file { "/srv/ips/ips$name":
    ensure => directory,
    mode => 755,
    owner  => "ips";
  }

  # reverse proxy configuration
  file { "/etc/apache2/sites-available/ips$name.conf":
    owner => "ips",
    notify => Exec["reload-apache2"],
    content => template("ips/reverse-proxy.conf.erb");
  }

  # upstart script
  file { "/etc/init/pkg.depotd$name.conf":
    owner => "root",
    group => "root",
    content => template("ips/pkg.depotd.conf.erb"),
    notify => Service["pkg.depotd$name"];
  }

  # SysV init compatibility layer
  file { "/etc/init.d/pkg.depotd$name":
    ensure => "/lib/init/upstart-job",
    notify => Service["pkg.depotd$name"];
  }

  # seed the initial empty repository if there's no data
  exec {  "seed$name":
    command => "tar xvzf ../empty-repo.tgz",
    cwd => "/srv/ips/ips$name",
    unless => "test -f /srv/ips/ips$name/cfg_cache"
  }

  # for some reason, the following doesn't do anything
  service { "pkg.depotd$name":
    ensure => "running",
    status => "status pkg.depotd$name | grep -q 'running'"
  }
}
