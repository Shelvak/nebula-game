class CreateLocationLock < ActiveRecord::Migration
  def self.up
    drop_table :location_locks
    create_table :location_locks, id: false do |t|
      t.belongs_to :location_galaxy
      t.belongs_to :location_solar_system
      t.belongs_to :location_ss_object
      t.integer :location_x
      t.integer :location_y
    end

    add_index :location_locks, [:location_galaxy_id, :location_x, :location_y],
      name: "galaxy_coordinates", unique: true
    add_fk :galaxies, :location_locks, target_key: :location_galaxy_id

    add_index :location_locks,
      [:location_solar_system_id, :location_x, :location_y],
      name: "solar_system_coordinates", unique: true
    add_fk :solar_systems, :location_locks,
      target_key: :location_solar_system_id

    add_index :location_locks, :location_ss_object_id, name: "ss_object",
      unique: true
    add_fk :ss_objects, :location_locks, target_key: :location_ss_object_id
  end

  def self.down
    drop_table :location_locks
  end
end