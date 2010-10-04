class AddNextToRouteHop < ActiveRecord::Migration
  def self.up
    change_table :route_hops do |t|
      t.boolean :next, :default => false, :null => false
    end

    add_index :route_hops, [:route_id, :next], :name => "next"
  end

  def self.down
    raise IrreversibleMigration
  end
end