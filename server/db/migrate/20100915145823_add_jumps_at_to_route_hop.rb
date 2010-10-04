class AddJumpsAtToRouteHop < ActiveRecord::Migration
  def self.up
    change_table :route_hops do |t|
      t.datetime :jumps_at, :null => true, :default => nil
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end