# modify this file to locally try the puppet manifest with vagrant
node /^lucid32$/ {
    include base

    ## to test Confluence with Vagrant, you need the following manual setup
    ##      - run ./confluence.deb/build.sh to generate Confluence debian package
    ##      - once provisioned, run 'make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/snakeoil.crt'
    ##        from inside the VM to generate a self-signed certificate named 'wiki2.jenkins-ci.org'
    ##      - add 'wiki2.jenkins-ci.org' to /etc/hosts as 127.0.0.1
    ##      - port-forwarding to port 80 and 443. Somehow vagrant port forwarding doesn't work.
    ##        iptables issue?
    include confluence
}

node default {
    include base
}

Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
