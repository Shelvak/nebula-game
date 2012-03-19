class UnpolymorphizeLocations < ActiveRecord::Migration
  def self.cleanup(table, prefix="location")
    query = "DELETE t.* FROM `#{table}` t"

    joins = ""
    wheres = []

    index = 0
    [
      [:galaxies, Location::GALAXY],
      [:solar_systems, Location::SOLAR_SYSTEM],
      [:ss_objects, Location::SS_OBJECT],
      [:units, Location::UNIT],
      [:buildings, Location::BUILDING],
    ].each do |ref_table, type|
      index += 1
      ref = "ref#{index}"

      joins += %Q{
      LEFT JOIN `#{ref_table}` #{ref}
      ON t.#{prefix}_id=#{ref}.id AND t.#{prefix}_type=#{type}
      }
      wheres << "#{ref}.id IS NULL"
    end

    query += joins + " WHERE " + wheres.map { |w| "(#{w})" }.join(" AND ")
    execute(query)
  end

  def self.alter(table, options)
    parts = []
    options[:prefixes].each do |prefix|
      (options[:add_columns] || []).each do |column|
        parts << "ADD `#{prefix}_#{column}` int(11)"
      end

      if options[:add_indexes]
        columns = options[:add_indexes][:columns]
        unique = options[:add_indexes][:unique]

        columns.each do |column|
          target_key = :"#{prefix}_#{column}_id"
          name = "#{prefix}_#{column}"
          idx = [target_key, "#{prefix}_x", "#{prefix}_y"].map { |i| "`#{i}`" }.
            join(", ")

          parts << "ADD #{unique ? "UNIQUE" : "INDEX"} `#{name}` (#{idx})"
        end
      end

      (options[:add_fks] || []).each do |fk_table|
        target_key = "#{prefix}_#{fk_table.to_s.singularize}_id"
        parts << %Q{ADD FOREIGN KEY (`#{target_key}`)
          REFERENCES `#{fk_table}` (`id`)
          ON DELETE CASCADE ON UPDATE CASCADE}
      end
    end

    parts += options[:parts] || []

    sql = parts.join(",\n")
    execute("ALTER TABLE `#{table}` #{sql}")
  end

  def self.remove_old_columns(table, prefixes=["location"])
    sql = prefixes.
      map { |prefix| "DROP `#{prefix}_id`, DROP `#{prefix}_type`" }.join(",\n")

    execute("ALTER TABLE `#{table}` #{sql}")
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

    alter(
      :cooldowns,
      :prefixes => [:location],
      :add_columns => [:galaxy_id, :solar_system_id, :ss_object_id],
      :add_indexes => {
        :columns => [:galaxy, :solar_system, :ss_object],
        :unique => true
      },
      :add_fks => [:galaxies, :solar_systems, :ss_objects],
      :parts => ["DROP INDEX `location`"]
    )

    transform_galaxy :cooldowns
    transform_solar_system :cooldowns
    transform_ss_object :cooldowns
    remove_old_columns :cooldowns

    ### route ###

    prefixes = [:source, :current, :target]
    prefixes.each do |prefix|
      cleanup :routes, prefix
    end

    alter(
      :routes,
      :prefixes => prefixes,
      :add_columns => [:galaxy_id, :solar_system_id, :ss_object_id],
      :add_indexes => {
        :columns => [:galaxy, :solar_system, :ss_object],
        :unique => false
      },
      :add_fks => [:galaxies, :solar_systems, :ss_objects]
    )

    prefixes.each do |prefix|
      transform_galaxy :routes, prefix
      transform_solar_system :routes, prefix
      transform_ss_object :routes, prefix
    end
    remove_old_columns :routes, prefixes

    ### route hops ###

    cleanup :route_hops

    alter(
      :route_hops,
      :prefixes => [:location],
      :add_columns => [:galaxy_id, :solar_system_id, :ss_object_id],
      :add_indexes => {
        :columns => [:galaxy, :solar_system, :ss_object],
        :unique => false
      },
      :add_fks => [:galaxies, :solar_systems, :ss_objects],
      :parts => [:galaxy, :solar_system, :ss_object].map do |column|
        "ADD INDEX `route_#{column}` (`route_id`, `location_#{column}_id`)"
      end + [
        "DROP INDEX `route`"
      ]
    )

    transform_galaxy :route_hops
    transform_solar_system :route_hops
    transform_ss_object :route_hops
    remove_old_columns :route_hops

    ### units ###

    types = [:galaxy, :solar_system, :ss_object, :building, :unit]
    cleanup :units

    fk_name = fk_name(:units, :galaxy_id)

    alter(
      :units,
      :prefixes => [:location],
      :add_columns => [
        :galaxy_id, :solar_system_id, :ss_object_id, :building_id, :unit_id
      ],
      :add_fks => [:galaxies, :solar_systems, :ss_objects, :buildings, :units],
      :parts => [
        "DROP INDEX `location`",
        "DROP INDEX `location_and_player`",
        "DROP FOREIGN KEY `#{fk_name}`",
        "DROP `galaxy_id`"
      ] + types.map { |type|
        "ADD INDEX `location_#{type}` (`player_id`, `location_#{type}_id`)"
      } + types.map { |type|
        "ADD INDEX `location_#{type}_and_player` (`location_#{type
          }_id`, `location_x`, `location_y`, `player_id`)"
      }
    )

    transform_galaxy :units
    transform_solar_system :units
    transform_ss_object :units
    transform_building :units
    transform_unit :units
    remove_old_columns :units

    ### wreckages ###

    cleanup :wreckages

    fk_name = fk_name(:wreckages, :galaxy_id)

    alter(
      :wreckages,
      :prefixes => [:location],
      :add_columns => [:galaxy_id, :solar_system_id],
      :add_indexes => {
        :columns => [:galaxy, :solar_system],
        :unique => true
      },
      :add_fks => [:galaxies, :solar_systems],
      :parts => [
        "DROP INDEX `location`",
        "DROP FOREIGN KEY `#{fk_name}`",
        "DROP `galaxy_id`"
      ]
    )

    transform_galaxy :wreckages
    transform_solar_system :wreckages
    remove_old_columns :wreckages
  end

  def self.down
    raise IrreversibleMigration
  end
end