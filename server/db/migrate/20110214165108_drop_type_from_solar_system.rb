class DropTypeFromSolarSystem < ActiveRecord::Migration
  def self.up
    remove_column :solar_systems, :type
  end

  def self.down
    raise IrreversibleMigration
  end
end