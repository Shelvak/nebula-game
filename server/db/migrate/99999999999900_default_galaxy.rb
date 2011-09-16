Galaxy.reset_column_information

class DefaultGalaxy < ActiveRecord::Migration
  def self.up
    galaxy_id = Galaxy.create_galaxy('dev', "localhost")
    Galaxy.create_player(galaxy_id, 0, "Test Player")
  end

  def self.down
    Galaxy.first.destroy
  end
end