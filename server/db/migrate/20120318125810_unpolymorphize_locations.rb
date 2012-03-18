class UnpolymorphizeLocations < ActiveRecord::Migration
  def self.cleanup(table, prefix="location")
    [
      [:galaxies, Location::GALAXY],
      [:solar_systems, Location::SOLAR_SYSTEM],
      [:ss_objects, Location::SS_OBJECT],
      [:buildings, Location::BUILDING],
      [:units, Location::UNIT],
    ].each do |ref_table, type|
      execute(%Q{
        DELETE t.* FROM `#{table}` t
        LEFT JOIN `#{ref_table}` ref ON t.#{prefix}_id=ref.id
        WHERE t.#{prefix}_type=#{type} AND ref.id IS NULL
      })
    end
  end

  def self.indexify(table, columns, prefix, options={})
    columns.each do |column|
      target_key = :"#{prefix}_#{column}_id"
      add_index table,
        [target_key, :"#{prefix}_x", :"#{prefix}_y"],
        options.merge(:name => "#{prefix}_#{column}")
      add_fk column.to_s.pluralize, table, :target_key => target_key
    end
  end

  def self.remove_old_columns(table, prefix="location")
    change_table table do |t|
      t.remove :"#{prefix}_id", :"#{prefix}_type"
    end
  end

  def self.transform(table, prefix, attr, type)
    execute(%Q{
      UPDATE `#{table}` SET #{prefix}_#{attr}_id=#{prefix}_id
      WHERE #{prefix}_type=#{type}
    })
  end

  def self.transform_galaxy(table, prefix="location")
    transform(table, prefix, :galaxy, Location::GALAXY)
  end

  def self.transform_solar_system(table, prefix="location")
    transform(table, prefix, :solar_system, Location::SOLAR_SYSTEM)
  end

  def self.transform_ss_object(table, prefix="location")
    transform(table, prefix, :ss_object, Location::SS_OBJECT)
  end

  def self.transform_building(table, prefix="location")
    transform(table, prefix, :building, Location::BUILDING)
  end

  def self.transform_unit(table, prefix="location")
    transform(table, prefix, :unit, Location::UNIT)
  end

  def self.up
    ### cooldowns ###

    cleanup :cooldowns

    change_table :cooldowns do |t|
      t.belongs_to :location_galaxy, :location_solar_system, :location_ss_object
    end

    indexify :cooldowns, [:galaxy, :solar_system, :ss_object],
      :location, :unique => true

    transform_galaxy :cooldowns
    transform_solar_system :cooldowns
    transform_ss_object :cooldowns
    remove_index :cooldowns, :name => :location
    remove_old_columns :cooldowns

    ### route ###

    [:source, :current, :target].each do |prefix|
      cleanup :routes, prefix

      change_table :routes do |t|
        t.belongs_to :"#{prefix}_galaxy", :"#{prefix}_solar_system",
          :"#{prefix}_ss_object"
      end

      indexify :routes, [:galaxy, :solar_system, :ss_object], prefix

      transform_galaxy :routes, prefix
      transform_solar_system :routes, prefix
      transform_ss_object :routes, prefix
      remove_old_columns :routes, prefix
    end

    ### route hops ###

    cleanup :route_hops

    change_table :route_hops do |t|
      t.belongs_to :location_galaxy, :location_solar_system, :location_ss_object
    end

    indexify :route_hops, [:galaxy, :solar_system, :ss_object], :location

    transform_galaxy :route_hops
    transform_solar_system :route_hops
    transform_ss_object :route_hops
    remove_index :route_hops, :name => :route
    [:galaxy, :solar_system, :ss_object].each do |column|
      add_index :route_hops, [:route_id, :"location_#{column}_id"],
        :name => "route_#{column}"
    end
    remove_old_columns :route_hops

    ### units ###

    cleanup :units

    change_table :units do |t|
      t.belongs_to :location_galaxy, :location_solar_system,
        :location_ss_object, :location_building, :location_unit
    end

    remove_index :units, :name => :location
    remove_index :units, :name => :location_and_player
    remove_fk :units, :galaxy_id
    remove_column :units, :galaxy_id

    transform_galaxy :units
    transform_solar_system :units
    transform_ss_object :units
    transform_building :units
    transform_unit :units

    types = [:galaxy, :solar_system, :ss_object, :building, :unit]
    types.each do |type|
      prefix = "location"
      target_key = :"#{prefix}_#{type}_id"

      add_index :units, [:player_id, target_key],
        :name => "#{prefix}_#{type}"

      add_index :units,
        [target_key, :"#{prefix}_x", :"#{prefix}_y", :player_id],
        :name => "#{prefix}_#{type}_and_player"
      add_fk type.to_s.pluralize, :units, :target_key => target_key
    end
    remove_old_columns :units

    ### wreckages ###

    cleanup :wreckages

    change_table :wreckages do |t|
      t.belongs_to :location_galaxy, :location_solar_system
      remove_fk :wreckages, :galaxy_id
      t.remove :galaxy_id
    end

    indexify :wreckages, [:galaxy, :solar_system], :location, :unique => true

    transform_galaxy :wreckages
    transform_solar_system :wreckages
    remove_index :wreckages, :name => :location
    remove_old_columns :wreckages
  end

  def self.down
    raise IrreversibleMigration
  end
end