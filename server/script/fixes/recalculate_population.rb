#!/usr/bin/env ruby

# Recalculates population.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

puts
players = Player.all
players.each_with_index do |player, index|
  $stdout.write "\r#{index + 1}/#{players.size}"

  player.population = player.units.map(&:population).sum
  player.population_cap = SsObject::Planet.where(:player_id => player.id).
    all.map do |planet|
      planet.buildings.reject(&:inactive?).map(&:population)
    end.flatten.sum + Cfg.player_initial_population
  player.save!
end

puts