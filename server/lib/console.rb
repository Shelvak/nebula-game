#!/usr/bin/env ruby
initializer = File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb'))
consolerc = File.expand_path(
  File.join(File.dirname(__FILE__), 'consolerc.rb'))
libs = "-r irb/completion -r '#{initializer}' -r '#{consolerc}'"

def is_windows?
  if RUBY_PLATFORM == "java"
    Java::java.lang.System.getProperty("os.name") =~ /Windows/i
  else
    RUBY_PLATFORM =~ /(:?mswin|mingw)/
  end
end

irb = is_windows? ? 'irb.bat' : 'irb'
puts "Starting irb..."
exec "#{irb} #{libs} --simple-prompt"
