class AddPlayerIdToConstructionQueueEntries < ActiveRecord::Migration
  def self.up
    change_table :construction_queue_entries do |t|
      t.belongs_to :player
    end

    add_fk("players", "construction_queue_entries")
  end

  def self.down
    raise IrreversibleMigration
  end
end