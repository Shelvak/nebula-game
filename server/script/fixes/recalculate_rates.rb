#!/usr/bin/env ruby

# Recalculates resource rates in planets.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

SsObject::Planet.all.each do |planet|
  $stdout.write("P")
  
  galaxy = planet.solar_system.galaxy
  CONFIG.with_set_scope(galaxy.ruleset) do
    [:metal, :energy, :zetium].each do |resource|
      planet.send("#{resource}_generation_rate=", 0)
      planet.send("#{resource}_usage_rate=", 0)
    end

    planet.buildings.each do |building|
      $stdout.write("b")
      
      if building.class.manages_resources? && building.active?
        [:metal, :energy, :zetium].each do |resource|
          planet.send("#{resource}_generation_rate=",
            planet.send("#{resource}_generation_rate") +
            building.send("#{resource}_generation_rate")
          )
          planet.send("#{resource}_usage_rate=",
            planet.send("#{resource}_usage_rate") +
            building.send("#{resource}_usage_rate")
          )
        end
      end
    end
  end

  planet.save!
  $stdout.write(".")
end

puts