class confluence {
    include mysql

    class { 'mysql::server':
        # TODO: how to correctly protect a password?
        config_hash => { 'root_password' => 'changeme' }
    }

    mysql::db { 'confluence':
        user        => 'confluence',
        password    => 'changeme',
        host        => 'localhost',
        grant       => ['all'],
        charset     => 'utf8',
    }

    # TODO: figure out where to get the debian package
    
    $deb = 'atlassian-confluence_4.2.4-0_all.deb'
    
    file { "/tmp/${deb}":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/confluence/${deb}"
    }
    
    # user and group created by debian package
    package { "openjdk-6-jre":
        ensure  => present,
    }
    package { "atlassian-confluence":
        # ensure      => "4.2.4",
        provider    => dpkg,
        ensure      => latest,
        source      => "/tmp/${deb}",
    }
    
    file { "/etc/confluence/WEB-INF-classes/confluence-init.properties":
        source => "puppet:///modules/confluence/confluence-init.properties"
    }
}
