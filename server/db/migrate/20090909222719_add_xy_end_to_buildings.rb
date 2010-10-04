class AddXyEndToBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.integer :x_end, :y_end, :null => false
    end

    add_index :buildings, [:planet_id, :x, :y, :x_end, :y_end], 
      :name => "tiles_taken", :unique => true
  end

  def self.down
    raise IrreversibleMigration
  end
end