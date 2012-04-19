#!/usr/bin/env ruby

if ARGV.size == 0
  puts "Usage: #{$0} 'duration'"
  puts
  puts "Where:"
  puts "- *duration* is a time string. "
  puts "  E.g.: '5 minutes' or '1 hour'"
  puts
  puts "Arguments were:"
  puts "#{ARGV.inspect}"
  exit
end

duration = ARGV.join(" ")
unless duration.match(
  /^(\d)+ (seconds?|minutes?|hours?|days?|weeks?|months?|years?)$/
)
  $stderr.write("Cannot parse date sting: #{duration.inspect}\n")
  exit 1
end

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'

duration = eval(duration.gsub(" ", "."))
time_str = "INTERVAL #{duration} SECOND"

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
