class ChangeAllianceOwnerFk < ActiveRecord::Migration
  def self.up
    connection.execute("SET FOREIGN_KEY_CHECKS=0")
    remove_index :alliances, :name => "uniq_galaxy_name"
    remove_index :alliances, :name => "foreign_key"
    add_index :alliances, [:galaxy_id, :owner_id, :name], :name => "uniqueness",
              :unique => true
    connection.execute("SET FOREIGN_KEY_CHECKS=1")
  end

  def self.down
    raise IrreversibleMigration
  end
end