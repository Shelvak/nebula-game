class CreateWreckage < ActiveRecord::Migration
  def self.up
    create_table :wreckages do |t|
      t.belongs_to :galaxy
      t.integer :location_id, :null => false
      t.column :location_type, "tinyint unsigned not null"
      t.column :location_x, "smallint not null"
      t.column :location_y, "smallint not null"
      t.float :metal, :null => false, :default => 0
      t.float :energy, :null => false, :default => 0
      t.float :zetium, :null => false, :default => 0
    end

    add_index :wreckages, [:location_id, :location_type,
      :location_x, :location_y], :name => "location", :unique => true
    add_fk :galaxies, :wreckages
  end

  def self.down
    drop_table :wreckages
  end
end