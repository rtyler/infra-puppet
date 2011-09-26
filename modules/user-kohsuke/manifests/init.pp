class user-kohsuke {
    group {
        "kohsuke" :
            ensure  => present;
    }

    user {
        "kohsuke" :
            gid     => "kohsuke",
            groups  => "infraadmin",
            shell   => "/bin/bash",
            home    => "/home/kohsuke",
            ensure  => present,
            require => [
                        Group["kohsuke"],
                        Group["infraadmin"],
                        ];
    }

    file {
        "/home/kohsuke" :
            ensure      => directory,
            require     => User["kohsuke"],
            owner       => "kohsuke",
            group       => "kohsuke";
        "/home/kohsuke/.ssh" :
            ensure      => directory,
            require     => File["/home/kohsuke"],
            owner       => "kohsuke",
            group       => "kohsuke";
    }

    ssh_authorized_key {
        "kohsuke_1" :
            user        => "kohsuke",
            ensure      => present,
            require     => File["/home/kohsuke/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEArSave9EBJ2rP3Hm5PFyiOpfGsPhJwjqdyaVEwQruM0Fa8nWstla7cdSTSs/ClHn7I1uUzQvX+/+6m/HTVy/WIr0cIIxLDm8hXVLfCLddtvxnXx47fJY3ongasYJ4TarIGkMMX/Vg1JpP7XIkMczUSNRyeHg/bGfV+YCPFuSW+cj2M5yMOE1KyIVQQL/JZu7lu80Ara5+RWSITObdiHRpnNzvBdIyhkSCrG0N7QStIBnEaLU//K2AB5GbK/65+k7sklutcH18wSGridQCNJm4ODUxov+vVr2OH3oiv7gyHEE9TypRI9vS0HUmsD+moPq3O8y0xyP8xaJWkz2LKe8/5Q==",
            type        => "rsa",
            name        => "kohsuke@unicore.2010";

        "kohsuke_2" :
            user        => "kohsuke",
            ensure      => present,
            require     => File["/home/kohsuke/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEAv2C9H4ZadOCu1rDmou5xgTpWF+cEFHGfwIIkB3fIzjsMfKUjofjXeAf5XrS9oTsQlrr++LRriYKDCCE7l9IPilDJpeua/21S0nktU+2iXKqgiPCVTlVd6qMksqz8j+9oRPZc2AWzp955Kc67MiKHAuZBpuIl7DBTvxL8OLYz/qyh6XnF+kcvNr8xnZ2qYn8lmh1VFnVscEs/5XtKpKQjnwOW4PmJ4YUcZV+Jeg8Si2jDes/BOvVOPBDt5jgNSsUvvVZSKdBiz5ioIZGbqOrnOqCeuZvFemOjeeSKfJUJOBTGisRgsEfcJPFKlgsUDiekvIfqQiVIC3N+0qskKDNWTw==",
            type        => "rsa",
            name        => "hudson@sol";
    }
}
