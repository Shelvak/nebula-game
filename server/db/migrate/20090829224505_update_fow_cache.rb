class UpdateFowCache < ActiveRecord::Migration
  def self.up
    remove_index :fow_cache_entries, :name => 'main'
    add_index :fow_cache_entries, [:galaxy_id, :player_id, :solar_system_id], :unique => true,
      :name => "main"
  end

  def self.down
    raise IrreversibleMigration
  end
end