class DropShieldEndsAtOnSolarSystem < ActiveRecord::Migration
  def self.up
    remove_column :solar_systems, :shield_ends_at
  end

  def self.down
    raise IrreversibleMigration
  end
end