class user-jieryn {
    group {
        "jieryn" :
            ensure  => present;
    }

    user {
        "jieryn" :
            gid     => "jieryn",
            groups  => "infraadmin",
            shell   => "/bin/bash",
            home    => "/home/jieryn",
            ensure  => present,
            require => [
                        Group["jieryn"],
                        Group["infraadmin"],
                        ];
    }

    file {
        "/home/jieryn" :
            ensure      => directory,
            require     => User["jieryn"],
            owner       => "jieryn",
            group       => "jieryn";
        "/home/jieryn/.ssh" :
            ensure      => directory,
            require     => File["/home/jieryn"],
            owner       => "jieryn",
            group       => "jieryn";
    }

    ssh_authorized_key {
        "jieryn" :
            user        => "jieryn",
            ensure      => present,
            require     => File["/home/jieryn/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAADAQABAAABAQC/aWXsTuSt6b0BrjhIwZQjzE/n3PYlbWYOCYI35aLWJxoYxiLjdvSLmmiv9tMjy5w7q8FEWmTXYtIrrKbjb2Twbkj/iRcGTzQYrd0JoyrX4MNBhXxjYlBZepdoGnbVm1rsrPDI1kVgAfBGxe9LLgTv81NSaTyyTw8gW2rpEMAwjbm3iBWHscsHAI8smQJnO6F3Oy07MAt5notu/LElmtV8m2eKHYp4WyZxarEW+rLtYivHk18QDxc9cEuY6ThZpBM3cWze/AFWEb7KOCG8vGVDEZmU8I5Q8b+dcI/1LeRLwc6GcTrVgCjQoay8bW17Hf7csn2pETHV2orxyq+Yv6WD",
            type        => "rsa",
            name        => "jesse@ayn";
    }
}
