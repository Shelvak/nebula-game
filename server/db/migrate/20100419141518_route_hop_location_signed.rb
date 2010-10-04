class RouteHopLocationSigned < ActiveRecord::Migration
  def self.up
    change_table :route_hops do |t|
      t.change :location_x, 'int null'
      t.change :location_y, 'int null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end