#
# Attempt at Puppet-managing Confluence
#   Note that this isn't what's currently running wiki.jenkins-ci.org
#
class confluence {
    include mysql
    include apache2
    include apache2::log-rotation
    include confluence::config

    Class["apache2"] ->
        Class["mysql::server"] ->
            Class["confluence"] ->
                Class["confluence::config"]

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
    # $deb = 'atlassian-confluence_3.5.16-0_all.deb'

    file { "/tmp/${deb}":
        owner   => root,
        group   => root,
        mode    => 644,
        source  => "puppet:///modules/confluence/${deb}"
    }

    package { "openjdk-6-jre":
        alias  => 'jre',
        ensure => present;
    }
    # user and group created by debian package
    package { "atlassian-confluence":
        # ensure => "4.2.4",
        provider => dpkg,
        ensure   => latest,
        source   => "/tmp/${deb}",
        require  => Package['jre'];
    }
}

