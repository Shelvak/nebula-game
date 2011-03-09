class DropHpRemainder < ActiveRecord::Migration
  def self.up
    remove_column :buildings, :hp_remainder
    remove_column :units, :hp_remainder
  end

  def self.down
    raise IrreversibleMigration
  end
end