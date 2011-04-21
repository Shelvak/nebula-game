class AddAllianceCooldownToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.datetime :alliance_cooldown_ends_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end