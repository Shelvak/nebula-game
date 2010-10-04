class DropFowPlanetEntry < ActiveRecord::Migration
  def self.up
    drop_table :fow_planet_entries
  end

  def self.down
    raise IrreversibleMigration
  end
end