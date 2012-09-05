require 'rubygems'
require 'fileutils'
require 'blimpy'
require 'blimpy/cucumber'


Before do
  # Symlink my modules directory from within the "blimpy/cucumber" work
  # directory that we *should* be in at this point since the Before hook
  # inside of `blimpy/cucumber` should run first

  FileUtils.ln_s(File.join(@original_dir, 'modules'), 'modules')

  # Set some stupid Exec global configuration
  nodes << """
Exec {
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
}
"""
end
