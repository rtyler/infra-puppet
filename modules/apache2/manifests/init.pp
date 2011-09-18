
class apache2 {
    if $operatingsystem != "Ubuntu" {
        err("The apache2 module is not configured for $operatingsystem")
    }
    else {
        package {
            "apache2" :
                alias => "apache2",
                ensure  => installed;
        }
    }
}
