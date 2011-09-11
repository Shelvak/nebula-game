#!/usr/bin/env ruby

NAMES = [
  ["current", "Currently logged in"],
  ["24h", "Logged in 24h"],
  ["48h", "Logged in 48h"],
  ["1w", "Logged in 1wk"],
  ["2w", "Logged in 2wks"],
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
  require File.expand_path(File.dirname(__FILE__) + 
      '/../../lib/server/control_client.rb')
  
  begin
    client = ControlClient.new
    data = client.message('stats|players')
  rescue ControlClient::ConnectionError
    # Stub data if server is down.
    data = {}
    NAMES.each { |key, label| data[key] = -1 }
  end

  data.each do |key, value|
    puts "#{key}.value #{value}"
  end
end
