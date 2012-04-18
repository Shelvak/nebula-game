#!/usr/bin/env ruby
require 'pathname'

NAMES = [
  ["current", "Currently logged in"],
  ["1d", "Logged in 1d"],
  ["2d", "Logged in 2d"],
  ["3d", "Logged in 3d"],
  ["4d", "Logged in 4d"],
  ["5d", "Logged in 5d"],
  ["6d", "Logged in 6d"],
  ["7d", "Logged in 7d"],
  ["total", "Total no. of players"]
]

if ARGV[0] == "config"
  puts "graph_title User counts"
  puts "graph_category nebula44"
  puts "graph_args --base 1000 -l 0"
  puts "graph_vlabel Count"
  puts "graph_printf %6.0lf"
  NAMES.each do |name, label|
    puts "#{name}.label #{label}"
    puts "#{name}.type GAUGE"
    puts "#{name}.min 0"
  end
else
  require File.expand_path(
    File.dirname(Pathname.new(__FILE__).realpath) +
      '/../../lib/server/control_client.rb'
  )
  
  begin
    client = ControlClient.new
    data = client.message('player_stats')
  rescue ControlClient::ConnectionError
    # Stub data if server is down.
    data = {}
    NAMES.each { |key, label| data[key] = -1 }
  end

  data.each do |key, value|
    puts "#{key}.value #{value}"
  end
end
