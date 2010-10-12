class RouteHopLocationSigned < ActiveRecord::Migration
  def self.up
    change_table :route_hops do |t|
      t.change :location_x, 'int null', :default => nil
      t.change :location_y, 'int null', :default => nil
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end