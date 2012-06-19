class FseBegone < ActiveRecord::Migration
  def self.up
    drop_table :fow_ss_entries
    FowGalaxyEntry.where("alliance_id IS NOT NULL").delete_all
    remove_fk :fow_galaxy_entries, :alliance_id
    remove_column :fow_galaxy_entries, :alliance_id
    change_column :fow_galaxy_entries, :player_id, :integer, null: false
  end

  def self.down
    raise IrreversibleMigration
  end
end