class AddExplorationToPlanet < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      t.column :exploration_x, "tinyint(2) unsigned null"
      t.column :exploration_y, "tinyint(2) unsigned null"
      t.datetime :exploration_ends_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end