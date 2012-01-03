class RenameQuestHelpUrlIdToMainQuestSlides < ActiveRecord::Migration
  def self.up
    rename_column :quests, :help_url_id, :main_quest_slides
  end

  def self.down
    rename_column :quests, :main_quest_slides, :help_url_id
  end
end