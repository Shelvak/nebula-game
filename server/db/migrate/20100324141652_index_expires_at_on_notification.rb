class IndexExpiresAtOnNotification < ActiveRecord::Migration
  def self.up
    add_index(:notifications, :expires_at)
  end

  def self.down
    raise IrreversibleMigration
  end
end