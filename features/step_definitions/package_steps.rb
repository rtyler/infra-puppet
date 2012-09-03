When /^I provision the host twice$/ do
  # /var/lib/apt/lists/partial looks to be a good way to check when apt-get
  # update was last run
  step %{I provision the host}
  vm.ssh_into("stat /var/lib/apt/lists/partial | md5sum > /tmp/partial_stat_1")

  # Run the provision code again
  vm.bootstrap

  vm.ssh_into("stat /var/lib/apt/lists/partial | md5sum > /tmp/partial_stat_2")
end

Then /^apt\-get should only run once$/ do
  same = vm.ssh_into('diff -q /tmp/partial_stat_1 /tmp/partial_stat_2')
  expect(same).to be(true)
end

