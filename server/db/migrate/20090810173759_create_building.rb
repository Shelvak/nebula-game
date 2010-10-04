class CreateBuilding < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.belongs_to :planet
      t.integer :x, :y, :null => false
      t.integer :hp_mod, :construction_mod, :energy_mod, :null => false
      t.integer :level, :null => false, :default => 0
      t.string :type, :null => false
      t.datetime :construction_started, :construction_ends
      t.boolean :npc, :null => false, :default => false
    end

    # For construction management
    add_index :buildings, [:construction_ends]
    # For selecting offensive buildings in fighting
    add_index :buildings, [:planet_id, :type, :npc]
  end

  def self.down
    drop_table :buildings
  end
end