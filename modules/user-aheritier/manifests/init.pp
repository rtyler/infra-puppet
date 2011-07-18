class user-aheritier {
    group {
        "aheritier" :
            gid     => 5506,
            ensure  => present;
    }

    user {
        "aheritier" :
            uid     => 5505,
            gid     => 5506,
            groups  => "infraadmin",
            shell   => "/bin/bash",
            home    => "/home/aheritier",
            ensure  => present,
            require => [
                        Group["aheritier"],
                        Group["infraadmin"],
                        ];
    }

    file {
        "/home/aheritier" :
            ensure      => directory,
            require     => User["aheritier"],
            owner       => "aheritier",
            group       => "aheritier";
        "/home/aheritier/.ssh" :
            ensure      => directory,
            require     => File["/home/aheritier"],
            owner       => "aheritier",
            group       => "aheritier";
    }

    ssh_authorized_key {
        "aheritier" :
            user        => "aheritier",
            ensure      => present,
            require     => File["/home/aheritier/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAIEAvQwwtdd6moJF7OQEiCnNNs5XdeEUSbIBcVfQWaAFU32EXap59S56ABPSNBkXTqhVCR7jXKL6suqZuyAOyiYYYrUHQth6oMMk2110b+VZ1o2xxa9vbh918ivRbk4NLbhVwa9hy25u/YwS1Z5bB8ymORMbwen0QGSnikrkAL6IVi8=",
            type        => "rsa",
            name        => "aheritier";
    }
}
