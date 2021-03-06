#!/usr/bin/env ruby

# Applies hotfix to running server

if ARGV.size == 0
  puts "Usage: #{$0} 'hotfix_file' ['hotfix_file' ...]"
  puts
  puts "Arguments were:"
  puts "#{ARGV.inspect}"
  exit
end

require File.expand_path(File.dirname(__FILE__) + 
    '/../lib/server/control_client.rb')

hotfix_files = ARGV

hotfix = ""
hotfix_files.each do |hotfix_file|
  unless File.exists?(hotfix_file) && File.readable?(hotfix_file)
    puts "Please ensure that #{hotfix_file} exists and is readable!"
    exit 1
  end

  hotfix += File.read(hotfix_file) + "\n"
end

puts
puts "!!! WARNING !!!"
puts
puts "You're about to apply this hotfix to running server!"
puts
puts "==== HOTFIX CODE ===="
puts
puts hotfix
puts
puts "==== HOTFIX CODE ===="
puts
puts "Are you sure? Type YES to continue"
puts

answer = STDIN.gets.strip
unless answer == "YES"
  puts "Cancelling."
  exit 2
end

puts "Proceeding..."
puts
puts "Buckle Up Dorothy. Cause' Kansas, Is Going Bye-Bye!"
puts

begin
  client = ControlClient.new
  client.message('apply_hotfix', :hotfix => hotfix)
  puts "Seems that things went smoothly."
rescue GameServerConnector::RemoteError => e
  STDERR.write("Hotfix failed!\nError:\n#{e.message}\n")
  exit 3
rescue ControlClient::ConnectionError
  STDERR.write("Cannot connect to control server, is it down?\n")
  exit 4
end
