class UnpolymorphizeConstructors < ActiveRecord::Migration
  def self.up
    execute(%Q{
      ALTER TABLE `buildings`
      ADD `constructable_building_id` int(11),
      ADD FOREIGN KEY (`constructable_building_id`)
        REFERENCES `buildings` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
      ADD `constructable_unit_id` int(11),
      ADD FOREIGN KEY (`constructable_unit_id`)
        REFERENCES `units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
    })

    execute(%Q{
      UPDATE `buildings`
      SET constructable_building_id=constructable_id
      WHERE constructable_type='Building'
    })
    execute(%Q{
      UPDATE `buildings`
      SET constructable_unit_id=constructable_id
      WHERE constructable_type='Unit'
    })

    execute(%Q{
      ALTER TABLE `buildings`
      DROP `constructable_type`, DROP `constructable_id`
    })
  end

  def self.down
    raise IrreversibleMigration
  end
end