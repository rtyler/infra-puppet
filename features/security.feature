Feature: Secure hosts


  Scenario: Ensure the Nagios host is never blocked

    On OSUOSL managed hosts the "denyhosts" package is installed and sometimes
    the Nagios host (140.211.15.121) can be accidentally blacklisted by the
    program.

    Given I have an empty Linux machine
    And I have included the Jenkins base module
    When I provision the host
    Then the Nagios server should be whitelisted for denyhosts
