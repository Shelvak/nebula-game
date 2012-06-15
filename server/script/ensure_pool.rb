#!/usr/bin/env ruby

# Ensures pool in galaxy.

if ARGV.size != 3
  puts "Usage: ruby ensure_pool.rb galaxy_id zone_pool_size home_ss_pool_size"
  exit 1
end

galaxy_id, zone_pool_size, home_ss_pool_size = ARGV.map(&:to_i)

require File.expand_path(File.dirname(__FILE__) + '/../lib/initializer')
Logging::Writer.instance.level = Logging::Writer::LEVEL_INFO

galaxy = Galaxy.find(galaxy_id)
galaxy.pool_free_zones = zone_pool_size
galaxy.pool_free_home_ss = home_ss_pool_size

result = nil
while result.nil? || result.created_zones > 0 || result.created_home_ss > 0
  result = SpaceMule.instance.ensure_pool(galaxy, 10, 100)
end

puts "Done!"