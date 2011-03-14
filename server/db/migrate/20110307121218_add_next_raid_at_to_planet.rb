class AddNextRaidAtToPlanet < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      t.datetime :next_raid_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end