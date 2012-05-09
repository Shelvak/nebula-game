class AddSpawnCollumnsToSsobjects < ActiveRecord::Migration
  def self.up
    add_column :ss_objects, :spawn_counter, 'int unsigned NOT NULL',
      :default => 0
    add_column :ss_objects, :next_spawn, :datetime
  end

  def self.down
    remove_column :ss_objects, :spawn_counter
    remove_column :ss_objects, :next_spawn
  end
end