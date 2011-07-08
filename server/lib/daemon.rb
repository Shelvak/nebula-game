#!/usr/bin/env ruby

SERVER_NAME = 'nebula_server'
SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'main.rb'))
LOG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'log',
  'daemon.log'))

def server_process_line
  `ps aux`.split("\n").grep(/#{SERVER_NAME}/)[0]
end

def running?
  ! server_process_line.nil?
end

def server_pid
  server_process_line.split[1]
end

def kill_server(signal="")
  if running?
    pid = server_pid
    `kill #{signal} #{pid}`
  else
    puts "Server is not running."
  end
end

case ARGV[0]
when "start"
  unless running?
    $0 = SERVER_NAME
    
    # Clear the argv, because main.rb doesn't expect any arguments
    ARGV.clear

    pid = fork do
      log_file = File.open(LOG_PATH, 'a+')
      
      require "rubygems"
      require 'robustthread'
      RobustThread.logger = Logger.new(log_file)
      #RobustThread.exception_handler do |exception|
      #  email_me_the_exception(exception)
      #end
      
      STDIN.close
      STDOUT.reopen(log_file)
      STDERR.reopen(log_file)

      # Marker not to include IRB session.
      DAEMONIZED = true

      RobustThread.new(:label => SERVER_NAME) do
        require SERVER_PATH
      end
    end
    Process.detach pid
  else
    puts "Server is already running."
  end
when "stop"
  kill_server
when "hup"
  kill_server("-HUP")
else
  puts "Unknown argument: #{ARGV[0]}"
  puts "Usage: lib/daemon.rb start|stop|hup"
end
