#
#   Manifest that creates a `jenkins` user and drops the appropriate SSH key
#   into ~/.ssh/authorized_keys
#
#   This should help streamline setting up new build slaves

class ci-ssh-slave {
    include packages::subversion
    include packages::vncserver # for Xvnc support

    group {
        "jenkins" :
            ensure  => present;
    }

    user {
        "jenkins" :
            gid     => "jenkins",
            ensure  => present,
            shell   => "/bin/bash",
            home    => "/home/jenkins",
            require => [
                        Group["jenkins"],
                       ];
    }

    file {
        "/home/jenkins" :
            ensure      => directory,
            require     => User["jenkins"],
            owner       => "jenkins",
            group       => "jenkins";

        "/home/jenkins/.ssh" :
            ensure      => directory,
            require     => File["/home/jenkins"],
            owner       => "jenkins",
            group       => "jenkins";
    }

    ssh_authorized_key {
        "jenkins" :
            user    => "jenkins",
            ensure  => present,
            require => File["/home/jenkins/.ssh"],
            key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEA1l3oZpCJlFspsf6cfa7hovv6NqMB5eAn/+z4SSiaKt9Nsm22dg9xw3Et5MczH0JxHDw4Sdcre7JItecltq0sLbxK6wMEhrp67y0lMujAbcMu7qnp5ZLv9lKSxncOow42jBlzfdYoNSthoKhBtVZ/N30Q8upQQsEXNr+a5fFdj3oLGr8LSj9aRxh0o+nLLL3LPJdY/NeeOYJopj9qNxyP/8VdF2Uh9GaOglWBx1sX3wmJDmJFYvrApE4omxmIHI2nQ0gxKqMVf6M10ImgW7Rr4GJj7i1WIKFpHiRZ6B8C/Ds1PJ2otNLnQGjlp//bCflAmC3Vs7InWcB3CTYLiGnjrw==",
            type    => "rsa",
            name    => "hudson@cucumber";
    }

    package {
        'bundler':
            ensure   => 'installed',
            provider => 'gem';
        'libxml2-dev':  # for Ruby apps that require nokogiri
            ensure   => 'installed';
        'libxslt1-dev':  # for Ruby apps that require nokogiri
            ensure   => 'installed';
        'libcurl4-openssl-dev': # for curb gem
            ensure   => 'installed';
        'libopenssl-ruby': # for net/https
            ensure   => 'installed';
    }

    file {
        # put RubyGems bin directory into PATH
        "/etc/profile.d/gem.sh" :
            source => 'puppet:///modules/ci-ssh-slave/gem.sh';
    }
}
