class AddUniqueIndexesToMaps < ActiveRecord::Migration
  def self.up
    add_index :solar_systems, [:galaxy_id, :x, :y], :unique => true, :name => "uniqueness"
    add_index :planets, [:galaxy_id, :solar_system_id, :position], :unique => true,
      :name => "uniqueness"
    add_index :tiles, [:planet_id, :x, :y], :unique => true, :name => "uniqueness"
  end

  def self.down
    raise IrreversibleMigration
  end
end