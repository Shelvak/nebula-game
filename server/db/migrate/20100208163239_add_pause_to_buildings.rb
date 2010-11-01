class AddPauseToBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.column :pause_remainder, 'int unsigned null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end