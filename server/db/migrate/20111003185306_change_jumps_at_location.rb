class ChangeJumpsAtLocation < ActiveRecord::Migration
  def self.up
    change_table :route_hops do |t|
      t.remove :jumps_at
    end
    change_table :routes do |t|
      t.rename :first_hop, :jumps_at
      t.change :jumps_at, :datetime, :null => true
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end