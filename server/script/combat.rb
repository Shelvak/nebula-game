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
  planet = SsObject::Planet.new
  planet.id = 1
  planet.player_id = player_id
  planet.name = name
  planet
end

require 'benchmark'
require 'pp'

player_ids = [1, 2, 3, 4]

#transporter = create_unit(:mule, 0, 100, player_ids[0])
#create_transporter_unit(transporter, :trooper, 0, 100, player_ids[0])
#create_transporter_unit(transporter, :trooper, 1, 1, player_ids[0])
#
#units = [
#  transporter,
#  create_unit(:trooper, 0, 100, player_ids[2]),
#]

ground_units = %w{azure saboteur scorpion seeker shocker spy trooper
  gnat glancer spudder gnawer}
ground_units = %w{spudder gnawer}
space_units = %w{avenger crow cyrix dart demosis dirac mule rhyno}
building_types = %w{vulcan screamer thunder}

unit_count = 60
building_count = 0
battle_kind = :manual

case battle_kind
when :manual
  location = create_planet(player_ids[0], "zug zug")
  units = []
  60.times do |i|
    units.push create_unit("trooper", rand(2), 80 + rand(20), 
      player_ids[rand(2)])
  end
  25.times do |i|
    units.push create_unit("spudder", rand(2), 80 + rand(20),
      player_ids[2 + rand(2)])
  end
  buildings = [

  ]
else
  ground_unit_count = 0; space_unit_count = 0
  case battle_kind
  when :only_ground
    location = create_planet(player_ids[0], "zug zug")
    ground_unit_count = unit_count
  when :only_space
    location = SolarSystemPoint.new(1, 0, 0)
    space_unit_count = unit_count
  when :ground_and_space
    location = create_planet(player_ids[0], "zug zug")
    ground_unit_count = unit_count / 2
    space_unit_count = unit_count / 2
  when :ground_and_space_with_teleport
    location = create_planet(player_ids[0], "zug zug")
    ground_unit_count = unit_count / 2
    space_unit_count = unit_count / 2
  end

  units = []
  [
    [ground_unit_count, ground_units],
    [space_unit_count, space_units]
  ].each do |count, unit_types|
    1.upto(count) do |id|
      units.push create_unit(
        unit_types.random_element,
        rand(2),
        1 + rand(100),
        player_ids[(id - 1) % player_ids.size]
      )
    end
  end

  if battle_kind == :ground_and_space_with_teleport
    units.each do |transporter|
      if transporter.storage > 0
        while transporter.stored < transporter.storage / 4
          create_transporter_unit(transporter,
            ground_units.random_element,
            rand(2),
            1 + rand(100),
            transporter.player_id
          )
        end
      end
    end
  end

  buildings = []
  if location.is_a?(SsObject::Planet)
    building_count.times do
      buildings.push create_building(location, building_types.random_element)
    end
  end
end

require 'ruby-prof'
report = nil
combat = Combat.new(
  location,
  {
    1 => [
      create_player(player_ids[0], "orc"),
      create_player(player_ids[1], "undead"),
    ],
    2 => [
      create_player(player_ids[2], "human"),
      create_player(player_ids[3], "night elf")
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

if report.nil?
  puts "Combat could not be engaged."
else
  File.open(File.join(ROOT_DIR, 'combat.log'), 'wb') do |f|
    f.write report.replay_info.to_json
  end

  pp report.statistics
  pp report.outcomes
end