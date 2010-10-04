class ModifyFowSsEntries < ActiveRecord::Migration
  def self.up
    change_table :fow_ss_entries do |t|
      t.remove :alliance_planets
      t.remove :alliance_ships
      t.change :player_planets, :boolean, :null => true, :default => nil
      t.change :player_ships, :boolean, :null => true, :default => nil
      t.text :alliance_planet_player_ids
      t.text :alliance_ship_player_ids
      t.boolean :nap_planets, :nap_ships, :null => true, :default => nil
    end

    add_index :units, [:player_id, :location_id, :location_type],
      :name => "group_by_for_fowssentry_status_updates"
    add_index :planets, [:player_id, :solar_system_id],
      :name => "group_by_for_fowssentry_status_updates"
  end

  def self.down
    raise IrreversibleMigration
  end
end