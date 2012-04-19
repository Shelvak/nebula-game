#!/usr/bin/env ruby

# Recalculates scientist counts.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'
require File.dirname(__FILE__) + '/helpers/counter.rb'

scope = Player
scope = scope.where(:name => ARGV) unless ARGV.blank?

def debug(msg)
  puts msg if ENV['DEBUG'] == "1"
end

type = Building::ResearchCenter.to_s.demodulize
Counter.new(scope, "Player").each do |player|
  taken_scientists = 0
  total_scientists = 0
  total_str = lambda do
    "scientists: #{total_scientists - taken_scientists}, scientists_total: #{
      total_scientists}"
  end

  player.quest_progresses.where(:status => QuestProgress::STATUS_REWARD_TAKEN).
    includes(:quest).each do |qp|
      scientists = qp.quest.rewards.scientists
      unless scientists.nil?
        total_scientists += scientists
        debug "QP: +#{scientists}, #{total_str.call}"
      end
    end

  player.planets.each do |planet|
    planet.buildings.where(:type => type).active.each do |rc|
      scientists = rc.scientists
      total_scientists += scientists
      debug "B: +#{scientists}, #{total_str.call}"
    end

    # Subtract exploring scientists.
    scientists = planet.exploration_scientists
    if scientists != 0
      taken_scientists += scientists
      debug "EXP: -#{scientists}, #{total_str.call}"
    end
  end

  # Subtract researches
  player.technologies.upgrading.each do |technology|
    scientists = technology.scientists
    taken_scientists += scientists
    debug "TECH: -#{scientists}, #{total_str.call}"
  end

  player.scientists = total_scientists - taken_scientists
  player.scientists_total = total_scientists
  $stdout.write(" #{player.scientists}/#{player.scientists_total}")
  raise "WTF: #{player.scientists}/#{player.scientists_total}" \
    if player.scientists > player.scientists_total || player.scientists < 0 ||
    player.scientists_total < 0
  player.save!
end

puts
