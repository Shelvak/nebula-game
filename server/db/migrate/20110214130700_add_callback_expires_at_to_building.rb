class AddCallbackExpiresAtToBuilding < ActiveRecord::Migration
  def self.up
    add_column :buildings, :cooldown_ends_at, :datetime
  end

  def self.down
    raise IrreversibleMigration
  end
end