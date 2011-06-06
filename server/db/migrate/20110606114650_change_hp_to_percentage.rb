class ChangeHpToPercentage < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.remove :hp
      t.column :hp_percentage, 'float unsigned not null', :default => 1
    end
    
    change_table :buildings do |t|
      t.remove :hp
      t.column :hp_percentage, 'float unsigned not null', :default => 1
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end