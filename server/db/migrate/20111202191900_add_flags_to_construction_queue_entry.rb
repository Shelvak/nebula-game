class AddFlagsToConstructionQueueEntry < ActiveRecord::Migration
  def self.up
    add_column :construction_queue_entries, :flags, 'tinyint(2) unsigned',
               :null => false, :default => 0
  end

  def self.down
    remove_column :construction_queue_entries, :flags
  end
end