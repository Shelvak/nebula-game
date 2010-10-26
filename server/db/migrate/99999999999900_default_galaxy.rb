Galaxy.reset_column_information

class DefaultGalaxy < ActiveRecord::Migration
  def self.up
    galaxy = Galaxy.new
    galaxy.ruleset = 'dev'
    galaxy.save!

    galaxy.create_player("Test Player", "0" * 64)
  end

  def self.down
    Galaxy.first.destroy
  end
end