class FixNotificationIndexes < ActiveRecord::Migration
  def self.up
    add_index :notifications, [:player_id, :event],
              :name => "player_with_event"
    remove_index :notifications, :name => "player"
    remove_index :notifications, :name => "foreign_key"
    remove_index :notifications, :name => "index_notifications_on_expires_at"
  end

  def self.down
    raise IrreversibleMigration
  end
end
