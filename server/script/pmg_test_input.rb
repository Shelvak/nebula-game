#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

DEST = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'test_input.txt')
TEMPLATE =<<EOF
%config%
{"action": "create_players", "galaxy_id": 1, "ruleset": "default",  "players": {"player 1": "token 1"}}

EOF

File.open(DEST, "wb") do |file|
  file.write TEMPLATE.sub("%config%",
    {'action' => 'config', 'db' => USED_DB_CONFIG,
      'sets' => CONFIG.full_set_values}.to_json
  )
end
