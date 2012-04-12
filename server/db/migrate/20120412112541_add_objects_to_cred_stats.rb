class AddObjectsToCredStats < ActiveRecord::Migration
  def self.up
    add_column :cred_stats, :objects, 'varchar(65535)'
  end

  def self.down
    remove_column :cred_stats, :objects
  end
end