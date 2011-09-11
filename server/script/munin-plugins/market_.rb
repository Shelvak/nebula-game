#!/usr/bin/env ruby

# For gathering average rates/market offer counts.

# Usage:
#
# Link as: market_{counts,rates}_{resource}_{resource}
# where resource is one of the: metal, energy, zetium, creds
#

COUNTS = 'counts'
RATES = 'rates'

KIND_NAMES = {
  0 => "metal",
  1 => "energy",
  2 => "zetium",
  3 => "creds"
}
KIND_NAMES_FLIPPED = KIND_NAMES.keys.inject({}) do |hash, key|
  hash[KIND_NAMES[key]] = key
  hash
end

basename = File.basename(File.expand_path(__FILE__))
match = basename.match(
  %r{
    ^
    market_
    (#{COUNTS}|#{RATES})_
    (#{KIND_NAMES[0]}|#{KIND_NAMES[1]}|#{KIND_NAMES[2]}|#{KIND_NAMES[3]})_
    (#{KIND_NAMES[0]}|#{KIND_NAMES[1]}|#{KIND_NAMES[2]}|#{KIND_NAMES[3]})
    $
  }x
)

if match.nil?
  STDERR.write("Unknown basename! #{basename.inspect}\n")
  exit 1
end

require File.expand_path(File.dirname(__FILE__) +
    '/../../lib/server/control_client.rb')

begin
  client = ControlClient.new

  type = match[1]
  from_kind = KIND_NAMES_FLIPPED[match[2]]
  to_kind = KIND_NAMES_FLIPPED[match[3]]
  data = client.message("stats|market_#{type}",
    {'from_kind' => from_kind, 'to_kind' => to_kind})

  if ARGV[0] == "config"
    info = type == COUNTS ? "Market offer counts" : "Market rate average"
    puts "graph_title #{info} (#{match[2]} to #{match[3]})"
    puts "graph_category nebula44_market"
    puts "graph_args --base 1000 -l 0"
    puts "graph_vlabel #{type == COUNTS ? 'Count' : 'Rate'}"
    puts "graph_printf #{type == COUNTS ? '%6.0lf' : '%4.3lf'}"
    data.each do |galaxy_id, _|
      puts "g#{galaxy_id}.label Galaxy with ID #{galaxy_id}"
      puts "g#{galaxy_id}.type GAUGE"
      puts "g#{galaxy_id}.min 0"
    end
  else
    data.each do |galaxy_id, value|
      puts "g#{galaxy_id}.value #{value}"
    end
  end
rescue ControlClient::ConnectionError
  STDERR.write("Cannot connect to server!\n")
  exit 2
end