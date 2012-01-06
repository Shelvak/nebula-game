class AddCoordsIndexToSolarSystems < ActiveRecord::Migration
  def self.up
    add_index :solar_systems, [:galaxy_id, :x, :y], :name => "lookup"
  end

  def self.down
    remove_index :solar_systems, :name => "lookup"
  end
end