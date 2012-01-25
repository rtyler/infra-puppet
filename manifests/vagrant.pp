# modify this file to locally try the puppet manifest with vagrant
node /^lucid32$/ {
    include base

    #include ips
    #include mirrorbrain
    #include haproxy
}

node default {
    include base
}

Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
