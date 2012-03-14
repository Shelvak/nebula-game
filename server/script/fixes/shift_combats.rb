#!/usr/bin/env ruby

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

time = 4.days
time_str = "INTERVAL #{time} SECOND"

ActiveRecord::Base.transaction do
  puts "planet raids"
  SsObject::Planet.update_all "next_raid_at = next_raid_at + #{time_str}"
  puts "cooldowns"
  Cooldown.update_all "ends_at = ends_at + #{time_str}"
  puts "callbacks"
  ActiveRecord::Base.connection.execute(
    "UPDATE callbacks SET ends_at = ends_at + #{time_str} WHERE `event` IN (#{
      CallbackManager::EVENT_RAID}, #{CallbackManager::EVENT_DESTROY})"
  )
end
