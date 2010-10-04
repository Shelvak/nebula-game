class UpgradableQueueToConstructableQueue < ActiveRecord::Migration
  def self.up
    rename_table(:upgrade_queue_entries, :construction_queue_entries)
    rename_column(:construction_queue_entries, :upgradable_type,
      :constructable_type)
    remove_column(:construction_queue_entries, :upgradable_id)
  end

  def self.down
    raise IrreversibleMigration
  end
end