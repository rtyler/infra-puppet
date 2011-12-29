

task :lint do
  Dir.glob("manifests/*.pp") do |filename|
    puts "Linting: #{filename}"
    sh "puppet-lint --with-filename '#{filename}'"
  end
end
