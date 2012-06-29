require File.join(ROOT_DIR, 'config', 'quests.rb')
puts QUESTS.sync!

if Galaxy.count == 0
  ruleset = ENV['ruleset'] || 'dev'
  galaxy = Galaxy.create_galaxy(ruleset, "localhost", 1, 1)
  Galaxy.create_player(galaxy.id, 0, "Test Player", false)
  puts "Created first galaxy."
else
  puts "Galaxy already created."
end