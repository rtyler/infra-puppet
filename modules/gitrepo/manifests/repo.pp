
# create one Git repository
define gitrepo::repo($description) {
  $gitrepo_dir = $gitrepo::gitrepo_dir

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
