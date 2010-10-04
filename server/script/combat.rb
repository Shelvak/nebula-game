#!/usr/bin/env ruby
ENV['environment'] = 'test'
ENV['configuration'] = 'production'
require File.dirname(__FILE__) + '/../lib/initializer.rb'
#require 'ruby-prof'

def create_unit(id, type, flank, hp, player_id)
  klass = "Unit::#{type.to_s.camelcase}".constantize
  unit = klass.new(
    :hp => (klass.hit_points(1) * (hp.to_f / 100)).to_i,
    :level => 1,
    :xp => 0,
    :flank => flank,
    :player_id => player_id
  )
  unit.id = id
  unit
end

def create_building(id, planet, type)
  building = "Building::#{type.to_s.camelcase}".constantize.new
  building.id = id
  building.planet = planet
  building.level = 1
  building.hp = building.hit_points(1)
  building
end

def create_player(id, name)
  p = Player.new
  p.id = id
  p.name = name
  
  p
end

def create_planet(player_id, name)
  planet = Planet.new
  planet.id = 1
  planet.player_id = player_id
  planet.name = name
  planet
end

require 'benchmark'
require 'pp'


#create_unit(id, type, flank, hp, level, xp, player_id)

player_ids = [11, 12, 1, 15]

units = []

#units = [
#  create_unit(1, :trooper, 0, 1, player_ids[0]),
#  create_unit(2, :trooper, 0, 100, player_ids[2]),
#  create_unit(3, :trooper, 0, 100, player_ids[2]),
#  create_unit(4, :trooper, 0, 100, player_ids[2]),
#  create_unit(5, :trooper, 0, 100, player_ids[2]),
#]

unit_count = 360
1.upto(unit_count) do |id|
  units.push create_unit(
    id,
    %w{
      azure avenger crow cyrix dart mule rhyno saboteur scorpion
      seeker shocker spy trooper
    }.random_element,
#    %w{
#      trooper rhyno
#    }.random_element,
    rand(2),
    1 + rand(100),
    player_ids[(id - 1) * player_ids.size / unit_count]
  )
end

planet = create_planet(player_ids[0], "zug zug")
buildings = []
4.times do |i|
  buildings.push create_building(i + 1, planet, "Vulcan")
end

require 'ruby-prof'
report = nil
combat = Combat.new(
  planet,
  {
    1 => [
      create_player(player_ids[0], "orc"),
    ],
    2 => [
      create_player(player_ids[1], "human"),
    ],
    3 => [
      create_player(player_ids[2], "night elf"),
      create_player(player_ids[3], "undead")
    ]
  },
  {
#    1 => [2, 3],
#    2 => [1],
#    3 => [1]
  },
  units,
  buildings
)
#combat.debug = true

time = Benchmark.realtime do
  report = combat.run_combat
end

puts "Elapsed combat time: %3.4fs" % time

File.open(File.join(ROOT_DIR, 'combat.log'), 'wb') do |f|
  f.write report.replay_info.to_json
end

pp report.statistics
pp report.outcomes