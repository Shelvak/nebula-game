class CreateUpgradeQueueEntry < ActiveRecord::Migration
  def self.up
    create_table :upgrade_queue_entries do |t|
      t.string :upgradable_type, :null => false, :limit => 100
      t.integer :upgradable_id, :null => true
      t.integer :constructor_id, :count, :null => false

    end
    add_index :upgrade_queue_entries, :constructor_id
  end

  def self.down
    drop_table :upgrade_queue_entries
  end
end