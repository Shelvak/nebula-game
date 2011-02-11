#!/usr/bin/env ruby

NAMES = [
  ["current", "Currently logged in"],
  ["6h", "Logged in 6h"],
  ["12h", "Logged in 12h"],
  ["24h", "Logged in 24h"],
  ["48h", "Logged in 48h"],
]

if ARGV[0] == "config"
  puts "graph_title User counts"
  puts "graph_category nebula44"
  puts "graph_args --base 1000 -l 0"
  puts "graph_vlabel Count"
  NAMES.each do |name, label|
    puts "#{name}.label #{label}"
    puts "#{name}.type GAUGE"
    puts "#{name}.min 0"
  end
else
  require 'rubygems'
  require 'socket'
  require 'yaml'
  require 'json'
  config_file = File.join(File.dirname(__FILE__), '..', 'config',
    'application.yml')

  CONFIG = YAML.load(File.read(config_file))

  begin
    socket = TCPSocket.open("127.0.0.1", CONFIG['control']['port'])
    message = {:token => CONFIG['control']['token'],
      :action => 'statistics'}.to_json
    socket.write message
    data = JSON.parse(socket.gets)
  rescue Errno::ECONNREFUSED
    # Stub data if server is down.
    data = {}
    NAMES.each { |key, label| data[key] = -1 }
  end

  data.each do |key, value|
    puts "#{key}.value #{value}"
  end
end