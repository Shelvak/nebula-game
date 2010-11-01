class AddFowSsIndex < ActiveRecord::Migration
  def self.up
    add_index :fow_ss_entries, :solar_system_id
  end

  def self.down
    raise IrreversibleMigration
  end
end