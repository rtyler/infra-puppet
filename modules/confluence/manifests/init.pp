class confluence {
    include mysql
    include apache2

    include apache2::log-rotation

    Class["apache2"] ->
        Class["mysql::server"] ->
            Class["confluence"]

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

    package { "openjdk-6-jre":
        ensure  => present,
    }
    # user and group created by debian package
    package { "atlassian-confluence":
        # ensure      => "4.2.4",
        provider    => dpkg,
        ensure      => latest,
        source      => "/tmp/${deb}",
    }

    # confluence configuration files
    file {
    "/etc/confluence/WEB-INF-classes/confluence-init.properties":
        source => "puppet:///modules/confluence/confluence-init.properties"
        ;
    "/etc/confluence/conf/server.xml":
        source => "puppet:///modules/confluence/server.xml"
        ;
    "/srv/wiki/.my.cnf":
        source => "puppet:///modules/confluence/my.cnf"
        ;
    "/srv/wiki/convert-to-innodb.sh":
        source => "puppet:///modules/confluence/convert-to-innodb.sh"
        ;
    }

    # needed to run 'make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/snakeoil.crt'
    # to get the snake-oil certificate generated

    enable-apache-mod {
    "ssl":
        name    => "ssl"
        ;
    "proxy":
        name    => "proxy"
        ;
    "proxy_http":
        name    => "proxy_http"
        ;
    }

    # how do I default $name to $title?
    enable-apache-virtual-host { "wiki2.jenkins-ci.org":
        name => "wiki2.jenkins-ci.org",
        source => "puppet:///modules/confluence/wiki.jenkins-ci.org"
    }

    # TODO: stage https key files

    firewall {
    '100 accept inbound HTTP requests' :
        proto  => 'tcp',
        port   => 80,
        action => 'accept';

    '101 accept inbound HTTPs requests' :
        proto  => 'tcp',
        port   => 443,
        action => 'accept';
    }

}
