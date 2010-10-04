#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

DEST = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'test_input.txt')
TEMPLATE =<<EOF
# table name
#{TilesGenerator::TABLES.join(" ")}
# Galaxy id
10

# Send configuration
%config%
end_of_config

# planet_id width height type
generate 1 20 20 regular
generate 2 10 40 regular
generate 3 40 60 regular
homeworld 4
homeworld 5
EOF

File.open(DEST, "wb") do |file|
  file.write TEMPLATE.sub("%config%", 
    CONFIG.filter(TilesGenerator::CONFIG_FILTER).to_json.gsub(',"', ",\n\"")
  )
end
