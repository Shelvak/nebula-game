class AddUniqueIndexToSs < ActiveRecord::Migration
  def self.up
    remove_index :solar_systems, :name => :lookup
    add_index :solar_systems, [:galaxy_id, :x, :y],
      :name => :lookup, :unique => true
  end

  def self.down
    remove_index :solar_systems, :name => :lookup
    add_index :solar_systems, [:galaxy_id, :x, :y],
      :name => :lookup, :unique => false
  end
end