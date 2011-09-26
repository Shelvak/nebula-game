require File.join(ROOT_DIR, 'config', 'quests.rb')
puts QUESTS.sync!

if Galaxy.count == 0
  galaxy_id = Galaxy.create_galaxy('dev', "localhost")
  Galaxy.create_player(galaxy_id, 0, "Test Player")
  puts "Created first galaxy."
else
  puts "Galaxy already created."
end