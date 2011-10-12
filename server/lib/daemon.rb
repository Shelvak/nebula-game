#!/usr/bin/env ruby
SERVER_NAME = 'nebula_server'
SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'main.rb'))
STOPPED_NORMALLY = File.expand_path(File.join(File.dirname(__FILE__), '..',
  'run', 'stopped_normally'))

def server_process_line
  `ps aux`.split("\n").grep(/-Dname=#{SERVER_NAME}/)[0]
end

def running?
  ! server_process_line.nil?
end

def server_pid
  server_process_line.split[1]
end

def create_stopped_normally
  File.open(STOPPED_NORMALLY, 'w') do |f|
    f.write("Stopped @ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}\n")
  end
end

def remove_stopped_normally
  File.unlink(STOPPED_NORMALLY) if stopped_normally?
end

def stopped_normally?
  File.exists?(STOPPED_NORMALLY)
end

def start
  `#{File.expand_path(File.dirname(__FILE__) + '/daemon/runner.sh')
     } "#{SERVER_NAME}"`
end

case ARGV[0]
when "start"
  unless running?
    remove_stopped_normally
    start
  else
    puts "Server is already running."
  end
when "stop"
  create_stopped_normally
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
when "start-silent"
  start unless running? || stopped_normally?
else
  puts "Unknown argument: #{ARGV[0]}"
  puts "Usage: lib/daemon.rb start|stop|hup|status|start-silent"
end
