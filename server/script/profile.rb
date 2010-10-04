#!/usr/bin/env ruby
ENV['environment'] = 'test'
ENV['configuration'] = 'production'
require File.dirname(__FILE__) + '/../lib/initializer.rb'
require 'ruby-prof'

MAP_DEFAULT_WIDTH = 35
MAP_DEFAULT_HEIGHT = 20

if ARGV.size == 0
  puts "Usage: script/profile.rb galaxy|solar_system|planet|map [args]"
  puts "  if map: args = width height type"
  exit 1
else
  what = ARGV[0]
end

Galaxy
SolarSystem
PlanetMapGenerator
map = nil

puts "Profiling..."
result = RubyProf.profile do
  case what
  when 'galaxy'
    Galaxy.new.save!
  when 'galaxy_gen'
    SolarSystemsGenerator.new(1).create
  when 'solar_system'
    ss = SolarSystem.new
    ss.galaxy_id = 1
    ss.save!
  when 'planet'
    p = Planet.new
    p.solar_system_id = 1
    p.save!
  when 'map'
    map = PlanetMapGenerator.new
    width = (ARGV[1] || MAP_DEFAULT_WIDTH).to_i
    height = (ARGV[2] || MAP_DEFAULT_HEIGHT).to_i
    tiles = CONFIG['planet'][ARGV[3] || 'regular']['tiles']
    1000.times { map.generate(width, height, tiles) }
  end
end
puts "Done. Writing results to file..."
# Print a graph profile to text
file = File.new("#{what}_prof.html", "w")
printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(file, :min_percent => 0)
file.close
puts "Done."

puts "Map:\n%s" % map.to_s if what == 'map'
