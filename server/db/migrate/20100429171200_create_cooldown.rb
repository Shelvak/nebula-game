class CreateCooldown < ActiveRecord::Migration
  def self.up
    create_table :cooldowns do |t|
      t.column :location_id, 'int unsigned not null'
      t.column :location_type, 'tinyint(2) unsigned not null'
      t.column :location_x, 'int null'
      t.column :location_y, 'int null'
      t.datetime :expires_at, :null => false
    end

    add_index :cooldowns, [:location_id, :location_type, :location_x,
      :location_y], :name => "location", :unique => true
  end

  def self.down
    drop_table :cooldowns
  end
end