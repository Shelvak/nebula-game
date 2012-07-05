class FixCooldownPlanetUniqueIndex < ActiveRecord::Migration
  def self.up
    add_index :cooldowns, [:location_ss_object_id],
      name: :location_ss_object_good, unique: true
    remove_index :cooldowns, name: :location_ss_object
    rename_index :cooldowns, :location_ss_object_good, :location_ss_object
  end

  def self.down
    raise IrreversibleMigration
  end
end