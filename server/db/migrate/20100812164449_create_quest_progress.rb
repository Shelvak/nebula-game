class CreateQuestProgress < ActiveRecord::Migration
  def self.up
    create_table :quest_progresses do |t|
      t.belongs_to :quest, :null => false
      t.belongs_to :player, :null => false
      t.column :status, 'tinyint(2) unsigned not null'
      t.column :completed, 'tinyint(2) unsigned not null default 0'
    end

    add_index :quest_progresses, [:quest_id, :player_id],
      :name => "on_objective_complete", :unique => true
    add_index :quest_progresses, [:player_id, :status], :name => "listing"
    c = ActiveRecord::Base.connection
    c.execute "ALTER TABLE `quest_progresses` ADD FOREIGN KEY (
      `quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE"
    c.execute "ALTER TABLE `quest_progresses` ADD FOREIGN KEY (
      `player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE"
  end

  def self.down
    drop_table :quest_progresses
  end
end