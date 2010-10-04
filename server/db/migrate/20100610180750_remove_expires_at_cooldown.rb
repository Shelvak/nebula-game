class RemoveExpiresAtCooldown < ActiveRecord::Migration
  def self.up
    change_table :cooldowns do |t|
      t.remove :expires_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end