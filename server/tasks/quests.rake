def load_quests_definition
  require File.join(ROOT_DIR, 'config', 'quests.rb')
end

namespace :quests do
  desc "Load quests from definition file"
  task :load => "db:connection" do
    load_quests_definition
    puts QUESTS.sync!
  end
  
  desc "Check if definition and database is intact."
  task :check => "db:connection" do
    load_quests_definition
    errors = QUESTS.check
    if errors.blank?
      puts "Quests are OK."
    else
      puts "Following errors were found in quests:"
      errors.each do |quest_id, errors|
        puts
        puts "*** Quest ID #{quest_id} ***"
        puts
        errors.each do |error|
          puts "* #{error}"
        end
      end
    end
  end
end