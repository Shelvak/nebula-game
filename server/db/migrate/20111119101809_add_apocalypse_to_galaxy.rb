class AddApocalypseToGalaxy < ActiveRecord::Migration
  def self.up
    add_column :galaxies, :apocalypse_start, :datetime
  end

  def self.down
    remove_column :galaxies, :apocalypse_start
  end
end