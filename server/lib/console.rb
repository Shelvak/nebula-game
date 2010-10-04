#!/usr/bin/env ruby
initializer = File.join(File.dirname(__FILE__), 'initializer.rb')
libs = "-r irb/completion -r '#{initializer}'"

irb = RUBY_PLATFORM =~ /(:?mswin|mingw)/ ? 'irb.bat' : 'irb'
puts "Starting irb..."
exec "#{irb} #{libs} --simple-prompt"
