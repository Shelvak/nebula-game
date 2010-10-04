class DropNpcAddShootingBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.remove :npc
      t.remove_index \
        :name => 'index_buildings_on_planet_id_and_type_and_npc'
      t.index [:planet_id, :type], :name => "buildings_by_type"
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end