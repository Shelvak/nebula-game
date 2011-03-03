#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

players_linear = []
30.times do |i|
  p = {"player#{i}" => "player#{i}"}
  players_linear.push %{{"players": #{p.to_json}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}}
end
players_linear = players_linear.join("\n")

players = {}
30.times { |i| i += 100; players["player#{i}"] = "player#{i}" }
players["0" * 64] = "test"

DEST = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'test_input.txt')
TEMPLATE =<<EOF
%config%
{"from_jumpgate":null,"from":{"x":1,"type":1,"y":0,"id":3},"action":"find_path","to":{"x":0,"type":2,"y":0,"id":5},"from_solar_system":{"x":1,"y":1,"galaxy_id":2,"id":3},"to_jumpgate":null,"to_solar_system":{"x":1,"y":1,"galaxy_id":2,"id":3}}
{"from_ss_galaxy_coords": [0,0], "from_jumpgate":{"x":3,"type":2,"y":156,"id":6},"from":{"x":0,"type":2,"y":0,"id":5},"action":"find_path","to":{"x":0,"type":2,"y":0,"id":7},"from_solar_system":{"x":2,"y":3,"galaxy_id":2,"id":3},"to_ss_galaxy_coords": [0,0], "to_jumpgate":{"x":3,"type":2,"y":202,"id":8},"to_solar_system":{"x":5,"y":5,"galaxy_id":2,"id":4}}
{"action":"create_galaxy","ruleset":"default"}
{"players":{"arturaz":"f5zQsHvvRU16tlnfMhR6uM22ZsT66VsYzwwX8S9ZimUtqbuVDCyVv2Rg7iWOxYH1"}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}
#{players_linear}
{"players": #{players.to_json}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}
EOF

File.open(DEST, "wb") do |file|
  file.write TEMPLATE.sub("%config%",
    {'action' => 'config', 'db' => DB_CONFIG["test"],
      'sets' => CONFIG.full_set_values}.to_json
  )
end
