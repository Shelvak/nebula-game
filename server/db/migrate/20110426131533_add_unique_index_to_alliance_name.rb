class AddUniqueIndexToAllianceName < ActiveRecord::Migration
  def self.up
    add_index :alliances, [:name, :galaxy_id], :unique => true, 
      :name => "uniq_galaxy_name"
  end

  def self.down
    raise IrreversibleMigration
  end
end
