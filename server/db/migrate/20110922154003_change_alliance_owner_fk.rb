class ChangeAllianceOwnerFk < ActiveRecord::Migration
  def self.up
    connection.execute("SET FOREIGN_KEY_CHECKS=0")
    remove_index :alliances, :name => "uniq_galaxy_name"
    add_index :alliances, [:galaxy_id, :name], :name => "uniq_galaxy_name",
              :unique => true
    add_index :alliances, [:galaxy_id, :owner_id], :name => "uniq_galaxy_owner",
              :unique => true
    remove_index :alliances, :name => "foreign_key"
    connection.execute("SET FOREIGN_KEY_CHECKS=1")
  end

  def self.down
    connection.execute("SET FOREIGN_KEY_CHECKS=0")
    remove_index :alliances, :name => "uniq_galaxy_name"
    remove_index :alliances, :name => "uniq_galaxy_owner"
    add_index :alliances, [:name, :galaxy_id], :name => "uniq_galaxy_name",
              :unique => true
    add_index :alliances, :galaxy_id, :name => "foreign_key"
    connection.execute("SET FOREIGN_KEY_CHECKS=1")
  end
end