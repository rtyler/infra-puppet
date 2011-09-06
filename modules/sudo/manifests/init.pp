
class sudo {

    package {
        sudo:
            ensure => latest,
    }

    file { "/etc/sudoers":
        owner   => root,
        group   => root,
        mode    => 440,
        source  => "puppet:///modules/sudo/$sudo_role-sudoers",
        require => Package["sudo"],
        ensure  => file,
    }
}
