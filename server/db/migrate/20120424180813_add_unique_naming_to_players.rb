class AddUniqueNamingToPlayers < ActiveRecord::Migration
  def self.up
    add_index :players, [:galaxy_id, :name], :name => :naming, :unique => true
  end

  def self.down
    remove_index :players, :name => :naming
  end
end