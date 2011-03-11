class AddShields < ActiveRecord::Migration
  def self.up
    change_table :solar_systems do |t|
      t.datetime :shield_ends_at
      t.integer :shield_owner_id
    end

    foreign_key(:players, :solar_systems, :id, :shield_owner_id, "SET NULL")

    change_table :ss_objects do |t|
      t.datetime :shield_ends_at
      t.integer :shield_owner_id
    end

    foreign_key(:players, :ss_objects, :id, :shield_owner_id, "SET NULL")
  end

  def self.down
    raise IrreversibleMigration
  end
end