class AddVpsToAlliance < ActiveRecord::Migration
  def self.up
    change_table :alliances do |t|
      t.column :victory_points, "int unsigned not null", :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end