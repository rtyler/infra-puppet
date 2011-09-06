#
#   Root manifest to be run on cabbage
#

node /^cabbage$/ {
    $sudo_role = "standard"

    include base
}
