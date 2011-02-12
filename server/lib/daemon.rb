#!/usr/bin/env ruby
require "rubygems"
require 'robustthread'

SERVER_NAME = 'nebula_server'
SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'main.rb'))
LOG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'log',
  'daemon.log'))

RobustThread.logger = Logger.new(LOG_PATH)
#RobustThread.exception_handler do |exception|
#  email_me_the_exception(exception)
#end

def server_process_line
  `ps aux`.split("\n").grep(/#{SERVER_NAME}/)[0]
end

def running?
  ! server_process_line.nil?
end

def server_pid
  server_process_line.split[1]
end

case ARGV[0]
when "start"
  unless running?
    $0 = SERVER_NAME
    
    # Clear the argv, because main.rb doesn't expect any arguments
    ARGV.clear

    # Close console sockets, we won't need them anyway.
    $stdin.close
    $stdout.close
    $stderr.close

    pid = fork do
      RobustThread.new(:label => SERVER_NAME) do
        require SERVER_PATH
      end
    end
    Process.detach pid
  else
    puts "Server is already running."
  end
when "stop"
  if running?
    pid = server_pid
    `kill #{pid}`
  else
    puts "Server is not running."
  end
else
  puts "Unknown argument: #{ARGV[0]}"
  puts "Usage: lib/daemon.rb start|stop"
end