class BuildingsConstructionCycle < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.datetime :construction_updated_at
      t.boolean :active, :default => false, :null => false
      t.column :hp, 'int unsigned not null'
      t.column :hp_max, 'int unsigned not null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end