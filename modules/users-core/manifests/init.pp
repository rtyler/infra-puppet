class users-core {
    group {
        "infraadmin" :
            ensure  => present;
    }

    include user-tyler
    include user-kohsuke
    include user-abayer
    include user-mindless
    include user-jieryn
    include user-aheritier
}
