

task :lint do
  puts "Linting manifests"
  puts "-----------------"
  Dir.glob("manifests/*.pp") do |filename|
    sh "puppet-lint --with-filename '#{filename}'"
  end
  puts "-----------------"
  puts

  ##
  ## We're going to ignore all the submodules, since we don't really care how
  #crappy their code is
  ignores = []
  regex = /(".*?")/
  File.open('.gitmodules').each_line do |line|
    matches = line.match(regex)
    if matches
      ignores << matches[1].gsub('"', '')
    end
  end

  puts "Linting modules"
  Dir.glob("modules/**/*.pp") do |filename|
    found = false
    ignores.each do |ignore|
      if filename.start_with? ignore
        found = true
        break
      end
    end

    unless found
      sh "puppet-lint --with-filename '#{filename}'"
    end
  end
end
