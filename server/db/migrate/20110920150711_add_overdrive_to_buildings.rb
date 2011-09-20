class AddOverdriveToBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.boolean :overdriven, :null => false, :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end