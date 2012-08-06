#
# Hosts read-only Git repositories and expose it via Apache
#
class host-git-repositories {
    include apache2
    include apache2::log-rotation

    $gitrepo_dir="/var/www/git.jenkins-ci.org"

    file {
        $gitrepo_dir :
            ensure      => directory,
            owner       => 'www-data',
            group       => 'www-data'
    }

    git::repository {
        "all" :
            description => "Hi"
    }

    package {
        "gitweb" :
    }

    file {
        "/etc/gitweb.conf":
            source => 'puppet:///modules/host-git-repositories/gitweb.conf';
    }

    apache2::virtualhost {
        'git.jenkins-ci.org' :
            source => 'puppet:///modules/host-git-repositories/git.jenkins-ci.org';
    }
}

# create one Git repository
define git::repository($description) {
    # TODO: how do I do module-local or global variable?
    $gitrepo_dir="/var/www/git.jenkins-ci.org"

    exec {
        "create repository ${name}" :
            require => File[$gitrepo_dir],
            unless  => "test -d ${gitrepo_dir}/${name}.git",
            path    => ['/bin', '/usr/bin'],
            user    => 'www-data',
            command => "git init --bare ${gitrepo_dir}/${name}.git";
    }

    file {
        "${gitrepo_dir}/${name}.git/description":
            require => Exec["create repository ${name}"],
            content => $description
    }
}

# vim: shiftwidth=4 expandtab tabstop=4
