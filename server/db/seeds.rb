require File.join(ROOT_DIR, 'config', 'quests.rb')
puts QUESTS.sync!

if Galaxy.count == 0
  ruleset = ENV['ruleset'] || 'dev'
  galaxy = Galaxy.create_galaxy(ruleset, "localhost", 1, 1)
  CONFIG.with_set_scope(ruleset) do
    Galaxy.create_player(galaxy.id, 0, "Test Player", false)
  end
  puts "Created first galaxy."
else
  puts "Galaxy already created."
end