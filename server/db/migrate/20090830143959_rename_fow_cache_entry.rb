class RenameFowCacheEntry < ActiveRecord::Migration
  def self.up
    rename_table :fow_cache_entries, :fow_ss_entries
  end

  def self.down
    raise IrreversibleMigration
  end
end