class pkg-git::centos {
    package {
        "git" :
            alias   => git,
            ensure  => installed;
    }
}
