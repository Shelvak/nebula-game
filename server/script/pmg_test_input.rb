#!/usr/bin/env ruby

require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')
)

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
{"action":"create_galaxy","ruleset":"dev"}
{"players":{"arturaz":"f5zQsHvvRU16tlnfMhR6uM22ZsT66VsYzwwX8S9ZimUtqbuVDCyVv2Rg7iWOxYH1"}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}
#{players_linear}
{"players": #{players.to_json}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}
{"action":"find_path","from":{"id":92,"type":2,"x":2,"y":300},"from_jumpgate":{"id":90,"type":2,"x":3,"y":90},"from_solar_system":{"id":15,"x":6,"y":-8,"galaxy_id":2},"from_ss_galaxy_coords":[6,-8],"to":{"id":2,"type":0,"x":2,"y":-4},"to_jumpgate":null,"to_solar_system":null,"to_ss_galaxy_coords":null}
{"action":"find_path","from":{"id":17,"type":1,"x":0,"y":0},"from_jumpgate":null,"from_solar_system":{"id":17,"x":2,"y":-4,"galaxy_id":2},"from_ss_galaxy_coords":null,"to":{"id":126,"type":2,"x":0,"y":0},"to_jumpgate":null,"to_solar_system":{"id":17,"x":2,"y":-4,"galaxy_id":2},"to_ss_galaxy_coords":null}
EOF

File.open(DEST, "wb") do |file|
  file.write TEMPLATE.sub("%config%",
    {'action' => 'config', 'db' => DB_CONFIG["test"],
      'sets' => CONFIG.full_set_values}.to_json
  )
end
