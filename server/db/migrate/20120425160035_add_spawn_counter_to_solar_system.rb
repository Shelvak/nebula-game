class AddSpawnCounterToSolarSystem < ActiveRecord::Migration
  def self.up
    add_column :solar_systems, :spawn_counter, 'int(10) unsigned',
      :null => false, :default => 0
  end

  def self.down
    remove_column :solar_systems, :spawn_counter
  end
end