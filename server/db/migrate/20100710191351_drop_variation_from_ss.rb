class DropVariationFromSs < ActiveRecord::Migration
  def self.up
    remove_column :solar_systems, :variation
  end

  def self.down
    raise IrreversibleMigration
  end
end