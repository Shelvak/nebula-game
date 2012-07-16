#!/usr/bin/env ruby

# Recalculates population.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

puts
player_ids = without_locking do
  (ARGV.empty? ? Player.scoped : Player.where(:name => ARGV)).select("id").
    c_select_values
end
player_ids.each_with_index do |player_id, index|
  ActiveRecord::Base.transaction do
    player = Player.find(player_id)
    $stdout.write "\r#{player.name} @ galaxy id #{player.galaxy_id} (#{
      index + 1}/#{player_ids.size})"

    player.recalculate_population!
  end
end

puts