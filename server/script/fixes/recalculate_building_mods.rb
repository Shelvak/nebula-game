#!/usr/bin/env ruby

# Recalculates building mods.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

puts
mods = ARGV.empty? ? %w{energy constructor armor} : ARGV
condition = mods.map { |m| "#{m}_mod > 0" }.join(" OR ")
total = Building.where(condition).count
index = 1
Building.where(condition).find_each do |building|
  $stdout.write "\r#{building.class.to_s} @ P #{building.planet_id} (#{
    index}/#{total})"

  building.send :calculate_mods, true
  building.save!

  index += 1
end

puts