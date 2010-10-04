class RemoveQuestTexts < ActiveRecord::Migration
  def self.up
    change_table :quests do |t|
      t.remove :text
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end