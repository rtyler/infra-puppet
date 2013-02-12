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
        "kohsuke_unicorn" :
            user        => "kohsuke",
            ensure      => absent,
            type        => "rsa",
            name        => "kohsuke@unicorn.2010";

        "kohsuke_unicore" :
            user        => "kohsuke",
            ensure      => absent,
            type        => "rsa",
            name        => "kohsuke@unicore.2010";

        "kohsuke_1" :
            user        => "kohsuke",
            ensure      => present,
            require     => File["/home/kohsuke/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCzBy1GEihAxSgrsEANgCxYwxS8Yy0U7cKq/1MMtr4/IrW2m2rzDcr4a7ZG/p/XrchCMn5eIekq1dYHsB0hY81iJr7jMZi7XbQx/LohF833YhIRctALpNzPunqBxZvOUVDib/dfX6LuoZTOojI/W5UPYrzAjyrjKMQvF5Mo0LaZ6eN1LElVaGzWExqO7mNkOrJY3IVurPu81mK4E+59FHTuB/oIawHUlxjMgBFPGKZBmb0cyVyViEmY6E78bNcN+frdSxZ72gcK/J7l1gfGz6YNQX6hKA+3v2O+/6pHf282W2hy0u4nw2DTs5NrsTnG8koiivilXC3VbhgVmQnUFKx5",
            type        => "rsa",
            name        => "kohsuke@griffon.2013";

        "kohsuke_2" :
            user        => "kohsuke",
            ensure      => present,
            require     => File["/home/kohsuke/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEAv2C9H4ZadOCu1rDmou5xgTpWF+cEFHGfwIIkB3fIzjsMfKUjofjXeAf5XrS9oTsQlrr++LRriYKDCCE7l9IPilDJpeua/21S0nktU+2iXKqgiPCVTlVd6qMksqz8j+9oRPZc2AWzp955Kc67MiKHAuZBpuIl7DBTvxL8OLYz/qyh6XnF+kcvNr8xnZ2qYn8lmh1VFnVscEs/5XtKpKQjnwOW4PmJ4YUcZV+Jeg8Si2jDes/BOvVOPBDt5jgNSsUvvVZSKdBiz5ioIZGbqOrnOqCeuZvFemOjeeSKfJUJOBTGisRgsEfcJPFKlgsUDiekvIfqQiVIC3N+0qskKDNWTw==",
            type        => "rsa",
            name        => "hudson@sol";

        "kohsuke_3" :
            user        => "kohsuke",
            ensure      => present,
            require     => File["/home/kohsuke/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEA5tp6PrxFN9ecF2si/d+Vk5fqlXdXCCynNMObJwXMXAcqtqIKdVtRE2D4WR+q+IgkZAePaQGI2zojHjqUTRGgv3Jk8MUg8Vi/AgZaE4pWljrayYyw7qiEnx3sjmm3/CMOD4okCkQ32P1adoPVLrBSwDQTRomS40BnYlSjPqrU2khqyx/UzrPB6KB+PN6KEyDaKBQwwyJh8gceFN5TkMi+h6ZL2K7m1CPTBv/VaxiEBZ7PLJscOJJB/hIxPnvjnfKBxaszT6l8SObT3wyrHiN57BCKULAYnGge+GLtVqcjd0BoDl/FpEMbynGve5b3CQtqaw2yGYGBEeOe8eV4MSgL+Q==",
            type        => "rsa",
            name        => "root@cucumber";

    }
}
