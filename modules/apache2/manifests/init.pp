
class apache2 {
    if $operatingsystem != "Ubuntu" {
        err("The apache2 module is not configured for $operatingsystem")
    }
    else {
        package {
            "apache2" :
                alias => "apache2",
                ensure  => installed;
        }
    }
}

class apache2::functions {
    exec {
        "reload-apache2" :
            refreshonly => true,
            command => "/etc/init.d/apache2 reload",
            require => Package["apache2"];

        "restart-apache2" :
            refreshonly => true,
            command => "/etc/init.d/apache2 restart",
            require => Package["apache2"];
    }
}

define enable-apache-mod($mod_name) {
    include apache2::functions

    $availible_file_path = "/etc/apache2/mods-available/${mod_name}.load"
    $enabled_file_path = "/etc/apache2/mods-enabled/${mod_name}.load"

    file {
        $availible_file_path :
            ensure => present,
    }

    exec {
        "enable-${mod_name}" :
            require => [
                           Package["apache2"],
                           File[$availible_file_path],
                       ],
            unless => "test -f ${enabled_file_path}",
            command => "a2enmod ${mod_name}",
            notify => Exec["reload-apache2"];
    }
}
