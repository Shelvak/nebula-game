class AddHpRemainderToBuilding < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.column :hp_remainder, 'int unsigned not null default 0'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end