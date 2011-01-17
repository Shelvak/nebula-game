class AddCanDestroyBuildingAtToPlanet < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      t.datetime :can_destroy_building_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end