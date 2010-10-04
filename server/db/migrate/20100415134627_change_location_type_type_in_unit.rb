class ChangeLocationTypeTypeInUnit < ActiveRecord::Migration
  def self.up
    Unit.update_all("location_type='0'", "location_type='Galaxy'")
    Unit.update_all("location_type='1'", "location_type='SolarSystem'")
    Unit.update_all("location_type='2'", "location_type='Planet'")

    change_table :units do |t|
      t.change :location_type, 'tinyint(2) unsigned not null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end