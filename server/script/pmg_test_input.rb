#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

players = {}
30.times { |i| players["player#{i}"] = "player#{i}" }
players["test"] = "0000000000000000000000000000000000000000000000000000000000000000"

DEST = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'test_input.txt')
TEMPLATE =<<EOF
%config%
{"from_jumpgate":null,"from":{"x":1,"type":1,"y":0,"id":3},"action":"find_path","to":{"x":0,"type":2,"y":0,"id":5},"from_solar_system":{"x":1,"y":1,"galaxy_id":2,"id":3},"to_jumpgate":null,"to_solar_system":{"x":1,"y":1,"galaxy_id":2,"id":3}}
{"from_jumpgate":{"x":3,"type":2,"y":156,"id":6},"from":{"x":0,"type":2,"y":0,"id":5},"action":"find_path","to":{"x":0,"type":2,"y":0,"id":7},"from_solar_system":{"x":2,"y":3,"galaxy_id":2,"id":3},"to_jumpgate":{"x":3,"type":2,"y":202,"id":8},"to_solar_system":{"x":5,"y":5,"galaxy_id":2,"id":4}}
{"players":{"arturaz":"f5zQsHvvRU16tlnfMhR6uM22ZsT66VsYzwwX8S9ZimUtqbuVDCyVv2Rg7iWOxYH1"}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}
{"players": #{players.to_json}, "action":"create_players", "ruleset":"dev", "galaxy_id":1}
EOF

File.open(DEST, "wb") do |file|
  file.write TEMPLATE.sub("%config%",
    {'action' => 'config', 'db' => DB_CONFIG["test"],
      'sets' => CONFIG.full_set_values}.to_json
  )
end
