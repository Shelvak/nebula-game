#!/usr/bin/env ruby

# Gets player units out of nowhere (e.g. when SS gets destroyed)

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

c = ActiveRecord::Base.connection

c.transaction do
  Unit.where(
    "location_type=? AND player_id IS NOT NULL", Location::SOLAR_SYSTEM
  ).all.each do |unit|
    if SolarSystem.where(:id => unit.location.id).first.nil?
      $stdout.write(".")
      unit.location = unit.player.planets.first
      unit.save!
    end
  end
end

puts

# Run fix_visibility to ensure all visibility things are ok.
puts "Running fix_visiblity.rb"
`ruby fix_visibility.rb`