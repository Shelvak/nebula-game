class FseBegone < ActiveRecord::Migration
  def self.up
    drop_table :fow_ss_entries
    FowGalaxyEntry.where("alliance_id IS NOT NULL").delete_all
    remove_fk :fow_galaxy_entries, :alliance_id
    remove_index :fow_galaxy_entries, :name => :alliance_visiblity
    remove_column :fow_galaxy_entries, :alliance_id
    change_column :fow_galaxy_entries, :player_id, :integer, null: false
    remove_index :ss_objects, name: :index_planets_on_player_id_and_galaxy_id
    remove_index :ss_objects,
      name: :index_planets_on_galaxy_id_and_solar_system_id
    # Add first, remove later because of FK.
    add_index :ss_objects, [:player_id, :solar_system_id],
      name: :observer_player_ids
    remove_index :ss_objects,
      name: :group_by_for_fowssentry_status_updates
  end

  def self.down
    raise IrreversibleMigration
  end
end