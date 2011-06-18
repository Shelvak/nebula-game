class AddAchievementToQuest < ActiveRecord::Migration
  def self.up
    change_table :quests do |t|
      t.boolean :achievement, :null => false, :default => false
      t.change :rewards, :text, :null => true
    end

    add_index :quests, :achievement
  end

  def self.down
    raise IrreversibleMigration
  end
end