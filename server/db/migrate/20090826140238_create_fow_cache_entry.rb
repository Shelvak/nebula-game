class CreateFowCacheEntry < ActiveRecord::Migration
  def self.up
    create_table :fow_cache_entries do |t|
      t.belongs_to :galaxy, :solar_system, :player, :null => false
      t.integer :counter, :null => false, :default => 0
    end

    add_index :fow_cache_entries, [:galaxy_id, :solar_system_id, :player_id],
      :name => "main"
  end

  def self.down
    drop_table :fow_cache_entries
  end
end