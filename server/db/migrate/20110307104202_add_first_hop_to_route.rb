class AddFirstHopToRoute < ActiveRecord::Migration
  def self.up
    change_table :routes do |t|
      t.datetime :first_hop, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end