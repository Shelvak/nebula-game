class SwitchToFlagsOnUnitsAndTechs < ActiveRecord::Migration
  def self.up
    change_table :technologies do |t|
      t.rename :speed_up, :flags
      t.change :flags, "tinyint(2) unsigned", :null => false, :default => 0
    end
    change_table :units do |t|
      t.column :flags, "tinyint(2) unsigned", :null => false, :default => 0
    end
  end

  def self.down
    change_table :technologies do |t|
      t.change :flags, "tinyint(1) unsigned", :null => false, :default => 0
      t.rename :flags, :speed_up
    end
    remove_column :units, :flags
  end
end