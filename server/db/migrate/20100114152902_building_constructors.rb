class BuildingConstructors < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.belongs_to :constructor
      t.integer :currently_constructing, :constructing_max
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end