#!/usr/bin/env ruby

# Recalculates visibility counters for every SS in the server.

require File.dirname(__FILE__) + '/../../lib/initializer.rb'

c = ActiveRecord::Base.connection

c.transaction do
  rd = Building::Radar.all.map do |r|
    r.active? ? (r.deactivate!; r) : nil
  end.compact
  
  FowGalaxyEntry.delete_all
  FowSsEntry.delete_all

  SolarSystem.all.each do |ss|
    next if ss.main_battleground? || ss.wormhole?
    
    puts "SS: #{ss.inspect}"
    planets = ss.planets
    planet_ids = planets.map(&:id)
    in_planets = "(location_type=#{Location::SS_OBJECT
      } AND location_id IN (#{planet_ids.join(",")}))"
    units = Unit.find_by_sql("SELECT * FROM units WHERE (
      #{planet_ids.blank? ? "0=1" : in_planets} OR (
      location_type=#{Location::SOLAR_SYSTEM} AND location_id=#{ss.id})
    )")

    units = units.reject do |u|
      u.ground? || u.player_id.nil?
    end.group_to_hash do |unit|
      unit.player_id
    end

    counts = {}

    planets.each do |planet|
      unless planet.player_id.nil?
        player_id = planet.player_id
        counts[player_id] ||= 0
        counts[player_id] += 1
      end
    end

    units.each do |player_id, player_units|
      counts[player_id] ||= 0
      counts[player_id] += player_units.size
    end

    puts counts.inspect
    counts.each do |player_id, count|
      fse = FowSsEntry.new
      fse.solar_system_id = ss.id
      fse.player_id = player_id
      fse.counter = count
      fse.save!
      puts "  FSE: #{fse.inspect}"
    end
    FowSsEntry.recalculate(ss.id)
  end

  rd.each { |r| r.activate! }
end
