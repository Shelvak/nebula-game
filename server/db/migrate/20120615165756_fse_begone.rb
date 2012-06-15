class FseBegone < ActiveRecord::Migration
  def self.up
    drop_table :fow_ss_entries
    remove_fk :fow_galaxy_entries, :alliance_id
    remove_column :fow_galaxy_entries, :alliance_id
  end

  def self.down
    raise IrreversibleMigration
  end
end