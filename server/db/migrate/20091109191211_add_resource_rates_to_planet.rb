class AddResourceRatesToPlanet < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.column :metal_rate, 'int unsigned'
      t.column :energy_rate, 'int unsigned'
      t.column :zetium_rate, 'int unsigned'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end