require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send('disable_names_containing_dash')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_documentation')

PuppetLint.configuration.ignore_paths = ["modules/**/*.pp"]


def each_manifest(&block)
  Dir.glob("manifests/*.pp") do |filename|
    yield filename
  end

  Dir.glob("local-modules/**/*.pp") do |filename|
    yield filename
  end
end


desc "Validate the Puppet syntax of all manifests"
task :validate do
  each_manifest do |filename|
    sh "puppet parser validate '#{filename}'"
  end
end
