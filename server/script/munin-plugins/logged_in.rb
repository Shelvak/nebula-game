#!/usr/bin/env ruby
require 'pathname'

# The following describes the name of the field:
# The characters must be [a-zA-Z0-9_], while the first character must be
# [a-zA-Z_].
NAMES = [
  ["current", "Currently logged in"],
  ["in_1d", "Logged in 1d"],
  ["in_3d", "Logged in 3d"],
  ["in_7d", "Logged in 7d"],
  ["in_14d", "Logged in 14d"],
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
