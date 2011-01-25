class ChangePlanetNameLength < ActiveRecord::Migration
  def self.up
    change_column :ss_objects, :name, :string, :limit => 12
  end

  def self.down
    raise IrreversibleMigration
  end
end