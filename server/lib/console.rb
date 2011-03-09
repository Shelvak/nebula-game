#!/usr/bin/env ruby
initializer = File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb'))
consolerc = File.expand_path(
  File.join(File.dirname(__FILE__), 'consolerc.rb'))
libs = "-r irb/completion -r '#{initializer}' -r '#{consolerc}'"

irb = RUBY_PLATFORM =~ /(:?mswin|mingw)/ ? 'irb.bat' : 'irb'
puts "Starting irb..."
exec "#{irb} #{libs} --simple-prompt"
