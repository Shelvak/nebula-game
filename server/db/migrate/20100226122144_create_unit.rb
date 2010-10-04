class CreateUnit < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.column :hp, 'int unsigned not null'
      t.column :level, 'tinyint(2) unsigned not null'
      t.column :location_id, 'int unsigned not null'
      t.string :location_type, :null => false
      t.column :player_id, 'int unsigned'
      t.datetime :last_update
      t.datetime :upgrade_ends_at
      t.column :pause_remainder, 'int unsigned null'
    end
    add_index :units, [:player_id, :location_id, :location_type],
      :name => 'location'
  end

  def self.down
    drop_table :units
  end
end