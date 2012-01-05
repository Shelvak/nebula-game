class ChangeCombatLogStorageToBlob < ActiveRecord::Migration
  def self.up
    execute "TRUNCATE `combat_logs`"
    change_column :combat_logs, :info, 'LONGBLOB', :null => false
    execute "ALTER TABLE `combat_logs` DROP PRIMARY KEY"
    add_index :combat_logs, :sha1_id, :unique => true, :name => :lookup
    remove_column :combat_logs, :expires_at
    add_column :combat_logs, :id, :primary_key
  end

  def self.down
    execute "TRUNCATE `combat_logs`"
    change_column :combat_logs, :info, 'TEXT', :null => false
    remove_column :combat_logs, :id
    add_column :combat_logs, :expires_at, :datetime, :null => false
    execute "ALTER TABLE combat_logs` ADD PRIMARY KEY (`sha1_id`)"
  end
end