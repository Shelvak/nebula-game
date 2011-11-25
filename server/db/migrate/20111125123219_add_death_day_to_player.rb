class AddDeathDayToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :death_day, 'tinyint(2) unsigned', :null => false, :default => 0
    end

    add_index :players, [:galaxy_id, :planets_count], :name => "alive_players"
  end

  def self.down
    remove_column :players, :death_day
    remove_index :players, :name => "alive_players"
  end
end