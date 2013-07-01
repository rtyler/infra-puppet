class user-kbsingh {
    group {
        'kbsingh' :
            ensure  => present;
    }

    user {
        'kbsingh' :
            gid     => 'kbsingh',
            groups  => 'infraadmin',
            shell   => '/bin/bash',
            home    => '/home/kbsingh',
            ensure  => present,
            require => [
                        Group['kbsingh'],
                        Group['infraadmin'],
                        ];
    }

    file {
        '/home/kbsingh' :
            ensure      => directory,
            require     => User['kbsingh'],
            owner       => 'kbsingh',
            group       => 'kbsingh';
        '/home/kbsingh/.ssh' :
            ensure      => directory,
            require     => File['/home/kbsingh'],
            owner       => 'kbsingh',
            group       => 'kbsingh';
    }

    ssh_authorized_key {
        'kbsingh' :
            user        => 'kbsingh',
            ensure      => present,
            require     => File['/home/kbsingh/.ssh'],
            key         => 'AAAAB3NzaC1kc3MAAACBAOltOk+pDxG4dhaVF9BZ3EjQhUsuW6lUI2VJSOwiu3OTsSzg/E0H388GYcoeWDUVkjAbyBHHa9TOotPMUL0NlQqscjMmTDBQeSSXA2COv3RVGgE0Ddwlg7ap5cgFpkxloG3kz7rpFo+dRhEbb6+d3BvJHAXj5Mgr5yzgCe3LAAAAFQD0WvoxratLpy/b/B1eOusjFr93hQAAAIEAwwOL7ZIMF/Kye2zHCUz9dFpVX2rJCiYqRPlbFFHpQXMJGIcqT1u77MO2cB+D98wrNi+eSbMJQNW+LOhLHsq1bhuNy+44SWZ9UnL9z1vVLpwKc0IxAQnPiDSNLzKPVAOOjGkI6CfMDYH2uLbRLbOf3QgyJB5GNy1tarSo0i/wHQUAAACAOmZFJj3Y6FrbGNaE9lBbb1X22GlJTke3sYMBbXKVxEUh+7VJCz9SSienKiuFmcE1Ysi+7wWUenaSeQNot8/WL29SJCXp3TokPQL9zvFMj5Hn7nDSKJe0ZvUt0RfrU3j6kcrei5SkseW5QGPZXq1GzhLseSvS+SN44ZDEOU4BzM0=',
            type        => 'ssh-dss',
            name        => 'kbsingh@vayu.karan.org';
    }
}
# vim: shiftwidth=2 expandtab tabstop=2
