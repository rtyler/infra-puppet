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
}
