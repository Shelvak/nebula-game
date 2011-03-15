class AddEndsAtToCooldown < ActiveRecord::Migration
  def self.up
    change_table :cooldowns do |t|
      t.datetime :ends_at, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end