class users-core {
    group {
        "infraadmin" :
            gid     => 5500,
            ensure  => present;
    }

    include user-tyler
    include user-kohsuke
    include user-abayer
    include user-mindless
}
