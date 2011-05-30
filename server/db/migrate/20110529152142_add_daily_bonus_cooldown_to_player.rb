class AddDailyBonusCooldownToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :daily_bonus_at, :datetime
  end

  def self.down
    raise IrreversibleMigration
  end
end