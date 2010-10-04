class CreateObjective < ActiveRecord::Migration
  def self.up
    create_table :objectives do |t|
      t.belongs_to :quest, :null => false
      t.string :type, :null => false
      t.string :key, :length => 64
      t.column :count, 'tinyint(2) unsigned not null default 1'
      t.column :level, 'tinyint(2) unsigned'
    end

    add_index :objectives, :quest_id, :name => "quest_objectives"
    add_index :objectives, [:type, :key], :name => "on_progress"
    c = ActiveRecord::Base.connection
    c.execute "ALTER TABLE `objectives` ADD FOREIGN KEY (
      `quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE"
  end

  def self.down
    drop_table :objectives
  end
end