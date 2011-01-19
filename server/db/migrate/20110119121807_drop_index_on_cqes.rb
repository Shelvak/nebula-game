class DropIndexOnCqes < ActiveRecord::Migration
  def self.up
    remove_index :construction_queue_entries,
      :name => "index_upgrade_queue_entries_on_constructor_id"
  end

  def self.down
    raise IrreversibleMigration
  end
end