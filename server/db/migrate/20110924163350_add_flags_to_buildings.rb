class AddFlagsToBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.remove :overdriven
      t.column :flags, 'tinyint(2) unsigned', :null => false, :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end