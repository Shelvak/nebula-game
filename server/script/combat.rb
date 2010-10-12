#!/usr/bin/env ruby
ENV['environment'] = 'test'
ENV['configuration'] = 'production'
require File.dirname(__FILE__) + '/../lib/initializer.rb'
#require 'ruby-prof'

$last_unit_id = 0
def create_unit(type, flank, hp, player_id)
  klass = "Unit::#{type.to_s.camelcase}".constantize
  unit = klass.new(
    :hp => (klass.hit_points(1) * (hp.to_f / 100)).to_i,
    :level => 1,
    :xp => 0,
    :flank => flank,
    :player_id => player_id
  )
  $last_unit_id += 1
  unit.id = $last_unit_id
  unit
end

def create_transporter_unit(transporter, type, flank, hp, player_id)
  unit = create_unit(type, flank, hp, player_id)
  unless transporter.respond_to?(:units_stubbed)
    transporter.instance_eval do
      @units = []
    end
    def transporter.units; @units; end
    def transporter.units_stubbed; true; end
  end

  transporter.units.push unit
  transporter.stored += unit.volume

  unit
end

$last_building_id = 0
def create_building(planet, type)
  building = "Building::#{type.to_s.camelcase}".constantize.new
  $last_building_id += 1
  building.id = $last_building_id
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

player_ids = [11, 12, 1, 15]

transporter = create_unit(:mule, 0, 100, player_ids[0])
create_transporter_unit(transporter, :trooper, 0, 100, player_ids[0])
create_transporter_unit(transporter, :trooper, 1, 1, player_ids[0])

units = [
  transporter,
  create_unit(:trooper, 0, 100, player_ids[2]),
]

#units = []
#unit_count = 360
#1.upto(unit_count) do
#  units.push create_unit(
#    %w{
#      azure avenger crow cyrix dart dirac mule rhyno saboteur
#      scorpion seeker shocker spy trooper
#    }.random_element,
##    %w{
##      trooper rhyno
##    }.random_element,
#    rand(2),
#    1 + rand(100),
#    player_ids[(id - 1) * player_ids.size / unit_count]
#  )
#end

planet = create_planet(player_ids[0], "zug zug")
buildings = []
#4.times do
#  buildings.push create_building(planet, "Vulcan")
#end

require 'ruby-prof'
report = nil
combat = Combat.new(
  planet,
  {
    1 => [
      create_player(player_ids[0], "orc"),
    ],
    2 => [
      create_player(player_ids[2], "undead")
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
combat.debug = true

time = Benchmark.realtime do
  report = combat.run_combat
end

puts "Elapsed combat time: %3.4fs" % time

File.open(File.join(ROOT_DIR, 'combat.log'), 'wb') do |f|
  f.write report.replay_info.to_json
end

pp report.statistics
pp report.outcomes