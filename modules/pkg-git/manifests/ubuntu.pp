class pkg-git::ubuntu {
    package {
        "git-core" :
            alias   => git,
            ensure  => installed;
    }
}
