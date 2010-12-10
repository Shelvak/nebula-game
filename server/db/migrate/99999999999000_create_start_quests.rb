class CreateStartQuests < ActiveRecord::Migration
  def self.up
    require File.join(ROOT_DIR, 'config', 'quests.rb')
  end

  def self.down
    raise IrreversibleMigration
  end
end