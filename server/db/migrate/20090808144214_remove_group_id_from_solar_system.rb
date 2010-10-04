class RemoveGroupIdFromSolarSystem < ActiveRecord::Migration
  def self.up
    if SolarSystem.new.respond_to?(:group_id)
      change_table :solar_systems do |t|
        t.remove :group_id
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end