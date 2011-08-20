#!/usr/bin/env jruby

# Sends an announcement to server

if ARGV.size != 2
  puts "Usage: #{$0} 'ends_at' 'message'"
  puts
  puts "Where:"
  puts "- *ends_at* is a time string Chronic "
  puts "  (http://chronic.rubyforge.org/) can understand. "
  puts "  E.g.: 'in 5 minutes' or 'in 1 hour'"
  puts "- *message* is a string which will be reported to server users."
  puts
  puts "Arguments were:"
  puts "#{ARGV.inspect}"
  exit
end

require File.expand_path(File.dirname(__FILE__) + 
    '/../lib/server/control_client.rb')
require 'chronic'

ends_at = Chronic.parse(ARGV[0])
if ends_at.nil?
  $stderr.write("Cannot parse date sting: #{ARGV[0].inspect}\n")
  exit 1
end

message = ARGV[1]

begin
  client = ControlClient.new
  response = client.
    message('announce', :ends_at => ends_at, :message => message) 
  if response['success']
    puts "Announcement successful."
  else
    $stderr.write("Announcement failed!\nError: #{response['error']}\n")
    exit 3
  end
rescue ControlClient::ConnectionError
  $stderr.write("Cannot connect to control server, is it down?\n")
  exit 2
end
