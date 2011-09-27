#!/usr/bin/env ruby
SERVER_NAME = 'nebula_server'
SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'main.rb'))

def server_process_line
  `ps aux`.split("\n").grep(/-Dname=#{SERVER_NAME}/)[0]
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
    `#{File.expand_path(File.dirname(__FILE__) + '/daemon/runner.sh')
       } "#{SERVER_NAME}"`
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
when "hup"
  require File.dirname(__FILE__) + '/server/control_client'
  begin
    client = ControlClient.new
    client.message('reopen_logs')
  rescue ControlClient::ConnectionError
    puts "Unable to connect to server."
  end
when "status"
  puts running? ? "ok" : "error"
else
  puts "Unknown argument: #{ARGV[0]}"
  puts "Usage: lib/daemon.rb start|stop|hup|status"
end
