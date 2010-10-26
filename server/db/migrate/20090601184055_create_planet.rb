class CreatePlanet < ActiveRecord::Migration
  def self.up
    create_table :planets do |t|
      t.belongs_to :solar_system, :null => false
      t.integer :width, :height, :null => false
      t.integer :position, :angle, :variation, :null => false, :default => 0
      t.string :type, :null => false
    end
  end

  def self.down
    drop_table :planets
  end
end