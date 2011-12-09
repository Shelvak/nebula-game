class RemovePlayerIdFromConstructionQueueEntry < ActiveRecord::Migration
  def self.up
    remove_fk :construction_queue_entries, :player_id
    remove_column :construction_queue_entries, :player_id
  end

  def self.down
    raise IrreversibleMigration
  end
end