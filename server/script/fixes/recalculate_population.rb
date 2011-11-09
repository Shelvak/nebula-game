#!/usr/bin/env ruby

# Recalculates population.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

Player.all.each do |player|
  player.population = player.units.map(&:population).sum
  player.population_cap = SsObject::Planet.where(:player_id => player.id).
    all.map do |planet|
      planet.buildings.accept(&:active?).map(&:population)
    end.flatten.sum + Cfg.player_initial_population
  player.save!
  $stdout.write "."
end

puts