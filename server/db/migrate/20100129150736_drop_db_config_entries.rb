class DropDbConfigEntries < ActiveRecord::Migration
  def self.up
    drop_table :config_entries
  end

  def self.down
    raise IrreversibleMigration
  end
end