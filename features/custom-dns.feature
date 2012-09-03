Feature: Jenkins hosts should use our internal DNS
  As a machine in the Jenkins cluster
  I should be able to query our authoritative Jenkins DNS server
  in case none of my upstream DNS providers can resolve a jenkins-ci.org domain


  Scenario: Bootstrap a machine
    Given I have an empty Linux machine
    And I have included the Jenkins DNS module
    When I provision the host
    Then the Jenkins DNS server should be in the resolv.conf
