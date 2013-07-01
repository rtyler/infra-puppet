require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send('disable_names_containing_dash')
PuppetLint.configuration.send('disable_80chars')


def ignored_modules
  ##
  ## We're going to ignore all the submodules, since we don't really care how
  ## crappy their code is
  ignores = []
  regex = /(".*?")/
  File.open('.gitmodules').each_line do |line|
    matches = line.match(regex)
    if matches
      ignores << matches[1].gsub('"', '')
    end
  end
  return ignores
end

PuppetLint.configuration.ignore_paths = ignored_modules.map { |p| "#{p}/**/*.pp" }


def each_manifest(&block)
  Dir.glob("manifests/*.pp") do |filename|
    yield filename
  end

  Dir.glob("modules/**/*.pp") do |filename|
    found = false
    ignored_modules.each do |ignore|
      if filename.start_with? ignore
        found = true
        break
      end
    end

    unless found
      yield filename
    end
  end
end


desc "Validate the Puppet syntax of all manifests"
task :validate do
  each_manifest do |filename|
    sh "puppet parser validate '#{filename}'"
  end
end
