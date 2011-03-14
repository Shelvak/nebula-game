class AddWormholes < ActiveRecord::Migration
  def self.up
    add_column :solar_systems, :wormhole, :boolean, :null => false,
      :default => false
    change_table :solar_systems do |t|
      t.change :x, 'mediumint(9)', :null => true
      t.change :y, 'mediumint(9)', :null => true
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end