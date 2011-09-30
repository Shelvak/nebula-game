class DropShieldsFromPlanets < ActiveRecord::Migration
  def self.up
    remove_fk :ss_objects, :shield_owner_id
    change_table :ss_objects do |t|
      t.remove :shield_owner_id, :shield_ends_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end