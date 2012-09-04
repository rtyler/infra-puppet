Feature: Manage packages
  As a machine in the Jenkins cluster
  I should have predictable package management characteristics from
    * How often I update my local caches
    * What apt repos are allowed on the machine

  Scenario: Only periodically run "apt-get update"

    Instead of running `apt-get update` at the beginning of every Puppet run,
    we should only update at most once a day

    Given I have an empty Linux machine
    And I have included the Jenkins base module
    When I provision the host twice
    Then apt-get should only run once
