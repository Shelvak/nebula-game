class AddSpawnCollumnsToSsobjects < ActiveRecord::Migration
  def self.up
    add_column :ss_objects, :spawn_counter, 'int(9) unsigned', null: false,
      default: 0
    add_column :ss_objects, :next_spawn, :datetime
  end

  def self.down
    remove_column :ss_objects, :spawn_counter
    remove_column :ss_objects, :next_spawn
  end
end