class AddUnitsPlanetIndex < ActiveRecord::Migration
  def self.up
    add_index :units, [:location_type, :location_id, :location_x,
      :location_y, :player_id], :name => "location_and_player"
  end

  def self.down
    raise IrreversibleMigration
  end
end