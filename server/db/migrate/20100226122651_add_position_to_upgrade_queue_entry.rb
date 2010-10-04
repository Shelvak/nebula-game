class AddPositionToUpgradeQueueEntry < ActiveRecord::Migration
  def self.up
    change_table :upgrade_queue_entries do |t|
      t.column :position, 'smallint(2) unsigned not null default 0'
      t.index :position
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end