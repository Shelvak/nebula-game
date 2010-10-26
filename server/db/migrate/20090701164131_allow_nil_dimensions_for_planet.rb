class AllowNilDimensionsForPlanet < ActiveRecord::Migration
  def self.up
    change_column :planets, :width, :integer, :null => true
    change_column :planets, :height, :integer, :null => true
  end

  def self.down
    change_column :planets, :width, :integer, :null => false
    change_column :planets, :height, :integer, :null => false
  end
end