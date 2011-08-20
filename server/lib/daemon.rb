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
    `#{File.expand_path(File.dirname(__FILE__) + '/daemon/runner.sh')
       } "#{SERVER_NAME}"`
  else
    puts "Server is already running."
  end
when "stop"
  kill_server
when "hup"
  kill_server("-HUP")
when "status"
  puts running? ? "ok" : "error"
else
  puts "Unknown argument: #{ARGV[0]}"
  puts "Usage: lib/daemon.rb start|stop|hup|status"
end
