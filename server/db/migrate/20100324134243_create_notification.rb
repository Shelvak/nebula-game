class CreateNotification < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :player_id, :null => false
      t.datetime :created_at, :expires_at, :null => false
      t.column :event, 'tinyint(2) unsigned not null'
      t.text :params
      t.boolean :starred, :read, :null => false, :default => false
    end

    add_index :notifications, :player_id, :name => "player"
    add_index :notifications, [:read, :created_at], :name => "order"
  end

  def self.down
    drop_table :notifications
  end
end