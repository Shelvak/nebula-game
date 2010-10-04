class CreateFowPlanetEntry < ActiveRecord::Migration
  def self.up
    create_table :fow_planet_entries, :id => false do |t|
      t.belongs_to :galaxy, :solar_system, :planet, :player, :null => false
    end
    add_index :fow_planet_entries, [:galaxy_id, :solar_system_id, :planet_id, :player_id],
      :unique => true, :name => 'main'
  end

  def self.down
    drop_table :fow_planet_entries
  end
end