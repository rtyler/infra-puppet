class user-tyler {
    if $operatingsystem == "Ubuntu" {
        $zshpath = "/usr/bin/zsh"
    }
    else {
        # Assuming that all "else" will be Redhat-based
        $zshpath = "/bin/zsh"
    }


    group {
        "tyler" :
            ensure  => present;
    }

    user {
        "tyler" :
            gid     => "tyler",
            groups  => "infraadmin",
            shell   => $zshpath,
            home    => "/home/tyler",
            ensure  => present,
            require => [
                        Group["tyler"],
                        Group["infraadmin"],
                        Package["zsh"]
                        ];
    }

    file {
        "/home/tyler" :
            ensure      => directory,
            require     => User["tyler"],
            owner       => "tyler",
            group       => "tyler";
        "/home/tyler/.ssh" :
            ensure      => directory,
            require     => File["/home/tyler"],
            owner       => "tyler",
            group       => "tyler";
    }

    ssh_authorized_key {
        "tyler" :
            user        => "tyler",
            ensure      => present,
            require     => File["/home/tyler/.ssh"],
            key         => "AAAAB3NzaC1yc2EAAAABIwAAAQEAueiy12T5bvFhsc9YjfLc3aVIxgySd3gDxQWy/bletIoZL8omKmzocBYJ7F58U1asoyfWsy2ToTOY8jJp1eToXmbD6L5+xvHba0A7djYh9aQRrFam7doKQ0zp0ZSUF6+R1v0OM4nnWqK4n2ECIYd+Bdzrp+xA5+XlW3ZSNzlnW2BeWznzmgRMcp6wI+zQ9GMHWviR1cxpml5Z6wrxTZ0aX91btvnNPqoOGva976B6e6403FOEkkIFTk6CC1TFKwc/VjbqxYBg4kU0JhiTP+iEZibcQrYjWdYUgAotYbFVe5/DneHMLNsMPdeihba4PUwt62rXyNegenuCRmCntLcaFQ==",
            type        => "rsa",
            name        => "tyler@kiwi";
    }

    $vim = $operatingsystem ? {
            centos  => vim-enhanced,
            redhat  => vim-enhanced,
            default => vim
    }

    package {
        "zsh" :
            ensure  => installed;
        $vim :
            alias   => vim,
            ensure  => installed;
    }
}
