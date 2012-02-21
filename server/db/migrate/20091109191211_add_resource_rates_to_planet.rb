class AddResourceRatesToPlanet < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.column :metal_rate, 'int(10) unsigned'
      t.column :energy_rate, 'int(10) unsigned'
      t.column :zetium_rate, 'int(10) unsigned'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end