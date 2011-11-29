#!/usr/bin/env ruby

# Recalculates resource rates and storages in planets.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

total = SsObject::Planet.count

index = 1
puts

SsObject::Planet.find_each do |planet|
  $stdout.write("\rP #{planet.id} (#{index}/#{total})")

  solar_system = planet.solar_system
  galaxy = solar_system.galaxy
  CONFIG.with_set_scope(galaxy.ruleset) do
    [:metal, :energy, :zetium].each do |resource|
      planet.send("#{resource}_generation_rate=", 0)
      planet.send("#{resource}_usage_rate=", 0)
      planet.send("#{resource}_storage=", 0)
    end

    planet.buildings.each do |building|
      $stdout.write("b")
      
      if building.class.manages_resources?
        if building.active?
          Resources::TYPES.each do |resource|
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

        Resources::TYPES.each do |resource|
          planet.send("#{resource}_storage=",
            planet.send("#{resource}_storage") +
            building.send("#{resource}_storage")
          )
        end
      end
    end
  end

  planet.save!
  $stdout.write(".")
  index += 1
end

puts