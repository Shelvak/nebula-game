class CreateRoute < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.column :target_type, 'tinyint(2) unsigned not null'
      t.column :target_id, 'int unsigned not null'
      t.column :target_x, 'int unsigned null'
      t.column :target_y, 'int unsigned null'
      t.datetime :arrives_at, :null => false
      t.text :cached_units, :null => false
    end

    add_index :routes, [:target_type, :target_id],
      :name => "incoming_routes"
  end

  def self.down
    drop_table :routes
  end
end