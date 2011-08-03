Galaxy.reset_column_information

class DefaultGalaxy < ActiveRecord::Migration
  def self.up
    galaxy_id = Galaxy.create_galaxy('tutorial', "localhost")
    galaxy = Galaxy.find(galaxy_id)

    galaxy.create_player("Test Player", "0" * 64)
  end

  def self.down
    Galaxy.first.destroy
  end
end