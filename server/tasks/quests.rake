namespace :quests do
  desc "Load quests from definition file"
  task :load => "db:connection" do
    require File.join(ROOT_DIR, 'config', 'quests.rb')
  end
end