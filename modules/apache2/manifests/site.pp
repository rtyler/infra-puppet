
define apache2::site() {
  include apache2::functions

  $available_file_path = "/etc/apache2/sites-available/${name}"
  $enabled_file_path = "/etc/apache2/sites-enabled/${name}"

  exec {
    "enable-${name}" :
      require => [
        Package['apache2'],
        File[$available_file_path],
             ],
      unless  => "test -f ${enabled_file_path}",
      command => "a2ensite ${name}",
      notify  => Exec['reload-apache2'];
  }
}
