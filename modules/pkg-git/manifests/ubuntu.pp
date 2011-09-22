class pkg-git::ubuntu {
    $gitpkgname = $operatingsystem ? {
        redhat => git,
        default => git-core
    }

    package {
        "git-core" :
            name => $gitpkgname,
            alias   => git,
            ensure  => installed;
    }
}
