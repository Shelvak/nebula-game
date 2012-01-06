class ChangeSsIndexesForRelocation < ActiveRecord::Migration
  def self.up
    execute("SET FOREIGN_KEY_CHECKS=0")
    remove_index :solar_systems, :name => :uniqueness
    add_index :solar_systems, [:galaxy_id, :player_id, :kind],
              :name => :uniqueness, :unique => true
    execute("SET FOREIGN_KEY_CHECKS=1")
  end

  def self.down
    execute("SET FOREIGN_KEY_CHECKS=0")
    remove_index :solar_systems, :name => :uniqueness
    add_index :solar_systems, [:galaxy_id, :x, :y],
              :name => :uniqueness, :unique => true
    execute("SET FOREIGN_KEY_CHECKS=1")
  end
end