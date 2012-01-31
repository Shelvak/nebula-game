#!/usr/bin/env ruby

# Recalculates visibility counters for every SS in the server.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

c = ActiveRecord::Base.connection

LOGGER.except(:debug) do
  c.transaction do
    puts "Deactivating radars."
    radars = Building::Radar.all
    index = 1
    rd = radars.map do |r|
      $stdout.write "\r#{index}/#{radars.size}"
      index += 1
      r.active? ? (r.deactivate!; r) : nil
    end.compact
    puts

    puts "Deleting FowGalaxyEntries"
    FowGalaxyEntry.delete_all
    puts "Deleting FowSsEntries"
    FowSsEntry.delete_all

    SolarSystem.find_each do |ss|
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

      puts "Player counts (pid -> count): " + counts.inspect
      counts.each do |player_id, count|
        fse = FowSsEntry.new
        fse.solar_system_id = ss.id
        fse.player_id = player_id
        fse.counter = count
        fse.save!
        puts "  FSE P: #{fse.inspect}"
      end

      ally_grouped = counts.inject({}) do |hash, (player_id, count)|
        alliance_id = Player.find(player_id).alliance_id
        unless alliance_id.nil?
          hash[alliance_id] ||= 0
          hash[alliance_id] += count
        end
        hash
      end
      puts "Alliance counts (pid -> count): " + ally_grouped.inspect
      ally_grouped.each do |alliance_id, count|
        fse = FowSsEntry.new
        fse.solar_system_id = ss.id
        fse.alliance_id = alliance_id
        fse.counter = count
        fse.save!
        puts "  FSE A: #{fse.inspect}"
      end
      puts "Recalculating FSE for #{ss.id}"
      FowSsEntry.recalculate(ss.id)
    end

    puts "Activating radars..."
    index = 1
    rd.each do |r|
      r.activate!
      $stdout.write "\r#{index}/#{radars.size}"
      index += 1
    end
    puts
  end
end
