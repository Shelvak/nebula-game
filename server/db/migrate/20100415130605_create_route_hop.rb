class CreateRouteHop < ActiveRecord::Migration
  def self.up
    create_table :route_hops do |t|
      t.column :route_id, 'int unsigned not null'
      t.column :location_type, 'tinyint(2) unsigned not null'
      t.column :location_id, 'int unsigned not null'
      t.column :location_x, 'int unsigned null'
      t.column :location_y, 'int unsigned null'
      t.datetime :arrives_at, :null => false
      t.column :index, 'smallint not null'
    end

    add_index :route_hops, [:route_id, :index], :name => "next_hop",
      :unique => true
    add_index :route_hops, [:route_id, :location_type, :location_id],
      :name => "route"
  end

  def self.down
    drop_table :route_hops
  end
end