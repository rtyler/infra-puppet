
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

        service {
            "apache2" :
                ensure     => running,
                require => Package["apache2"],
                hasstatus       => true,
                hasrestart      => true,
                enable  => true;
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

define enable-apache-mod($name) {
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

define enable-apache-site($name) {
    include apache2::functions

    $available_file_path = "/etc/apache2/sites-available/${name}"
    $enabled_file_path = "/etc/apache2/sites-enabled/${name}"

    exec {
        "enable-${name}" :
            require => [
                           Package["apache2"],
                           File[$available_file_path],
                       ],
            unless => "test -f ${enabled_file_path}",
            command => "a2ensite ${name}",
            notify => Exec["reload-apache2"];
    }
}

# TODO: how do I default $name to $title?
define enable-apache-virtual-host($name,$source) {
    include apache2::functions

    file { "/etc/apache2/sites-available/${name}":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => $source,
        require => Package["apache2"],
    }
    file { "/etc/apache2/sites-enabled/${name}":
        ensure  => "../sites-available/${name}",
        notify  => Exec["reload-apache2"],
    }

    # directory to house log files
    file { "/var/log/apache2/${name}":
        ensure  => directory,
        owner   => root,
        mode    => 700
    }
}

# vim: shiftwidth=4 expandtab tabstop=4
