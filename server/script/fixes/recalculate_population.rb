#!/usr/bin/env ruby

# Recalculates population.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

puts
ActiveRecord::Base.transaction do
  players = ARGV.empty? ? Player.all : Player.where(:name => ARGV).all
  players.each_with_index do |player, index|
    $stdout.write "\r#{player.name} @ galaxy id #{player.galaxy_id} (#{
      index + 1}/#{players.size})"

    player.recalculate_population!
  end
end

puts