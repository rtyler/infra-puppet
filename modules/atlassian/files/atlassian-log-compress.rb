#!/usr/bin/env ruby
# Atlassian products configure Tomcat to generate xxxx.2012-12-25.log files
# this script compresses old log files

def rotate(dir)

  logs=Dir.glob(dir+"/*.*")

  # select uncompressed log files
  logs=logs.select { |f| f =~ /\.[0-9-]{10}\.log$/ }

  # group logs to domains
  groups = {}
  logs.each { |f|
    head = f[0...-15]
    g = groups[head]
    if !g then
      g = groups[head] = []
    end
    g << f
    # puts "#{head}\t#{f}";
  }
  groups.each { |k,v|
    puts k
    v = v.sort()
    v[0...-1].each { |f|
      puts "  Compressing #{f}"
      system "gzip #{f}"
    }
    puts "  Preserving  #{v[-1]}"
  }
end

ARGV.each { |d| rotate(d) }
# Dir.glob("*").select{|f| FileTest.directory?(f) }.each{|f| rotate(f) }
