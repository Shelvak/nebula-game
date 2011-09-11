class AddShields < ActiveRecord::Migration
  def self.up
    change_table :solar_systems do |t|
      t.datetime :shield_ends_at
      t.integer :shield_owner_id
    end

    add_fk(:players, :solar_systems, :target_key => :shield_owner_id,
      :on_delete => "SET NULL")

    change_table :ss_objects do |t|
      t.datetime :shield_ends_at
      t.integer :shield_owner_id
    end

    add_fk(:players, :ss_objects, :target_key => :shield_owner_id,
      :on_delete => "SET NULL")
  end

  def self.down
    raise IrreversibleMigration
  end
end