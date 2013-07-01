class user-abayer {
    group {
        "abayer" :
            ensure  => present;
    }

    user {
        "abayer" :
            gid     => "abayer",
            groups  => "infraadmin",
            shell   => "/bin/bash",
            home    => "/home/abayer",
            ensure  => present,
            require => [
                        Group["abayer"],
                        Group["infraadmin"],
                        ];
    }

    file {
        "/home/abayer" :
            ensure      => directory,
            require     => User["abayer"],
            owner       => "abayer",
            group       => "abayer";
        "/home/abayer/.ssh" :
            ensure      => directory,
            require     => File["/home/abayer"],
            owner       => "abayer",
            group       => "abayer";
    }

    ssh_authorized_key {
        "abayer" :
            user        => "abayer",
            ensure      => present,
            require     => File["/home/abayer/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEA402I3RoTGntFReTPTs5UGO2HkU4UN3PDZ/slALFXRC6qKMhdySzHfIXJTVx8IE7Z/TcBuM411Hy/HwTZFZBihw/B8mD6ubut5py0GUc8sI/Qo7++1qaEjhXg6aLZGqu+USH0aE/fgqzZq1o8YF+HxuN5FhWKsbL3T1ukf387gT6rhuUje4Ch9ko/h40IsIyvpcqVCGo47SfDz+lCT2A0mXp/rtJRYOTGdqLAUcJ1zZNawf7FrxGtphuppgyGYFHT+qq4lRRlgVu6rZrAWWoDPPexGB4XuRrbcgKXZ595WQjpx+zlz6Og5TNX4bvX59MQPKr8cg3Qj842ZfOgPkBvOw==",
            type        => "rsa",
            name        => "abayer@abayer-laptop";
    }
}
