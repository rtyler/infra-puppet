
class pkg-apache2 {
    if $operatingsystem != "Ubuntu" {
        err("pkg-apache2 is not configured for $operatingsystem")
    }
    else {
        package {
            "apache2" :
                alias => "apache2",
                ensure  => installed;
        }
    }
}
