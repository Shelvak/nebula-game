#!/usr/bin/env ruby
SERVER_NAME = 'nebula_server'
SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'main.rb'))
PID_FILE = File.expand_path(File.join(File.dirname(__FILE__), '..',
  'run', 'daemon.pid'))

def is_alive?(pid)
  ! `ps aux | awk {'print $2'}`.split("\n").index(pid.to_s).nil?
end

def server_pid
  if pid_file?
    pid = File.read(PID_FILE).to_i
    is_alive?(pid) ? pid : nil
  else
    nil
  end
end

def running?
  ! server_pid.nil?
end

def remove_pid_file
  File.unlink(PID_FILE) if pid_file?
end

def pid_file?
  File.exists?(PID_FILE)
end

def start
  `#{File.expand_path(File.dirname(__FILE__) + '/daemon/runner.sh')
     } "#{SERVER_NAME}"`
end

def wait_until_dead
  STDOUT.write "Waiting for process to disappear..."
  while running?
    sleep 1
    STDOUT.write(".")
  end
  puts " Dead!"
end

case ARGV[0]
when "start"
  unless running?
    start
  else
    puts "Server is already running."
  end
when "stop", "force-stop"
  if running?
    pid = server_pid
    `kill #{ARGV[0] == "force-stop" ? "-9" : ""} #{pid}`
    wait_until_dead
    remove_pid_file
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
  puts "Usage: lib/daemon.rb start|stop|force-stop|hup|status"
end
