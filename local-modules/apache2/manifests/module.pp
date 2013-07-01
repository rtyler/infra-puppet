define apache2::module {
  include apache2::functions

  $available_file_path = "/etc/apache2/mods-available/${name}.load"
  $enabled_file_path = "/etc/apache2/mods-enabled/${name}.load"

  file {
    $available_file_path :
      ensure => present,
  }

  exec {
    "enable-${name}" :
      require => [
               Package["apache2"],
               File[$available_file_path],
             ],
      unless => "test -f ${enabled_file_path}",
      command => "a2enmod ${name}",
      notify => Exec["reload-apache2"];
  }
}
