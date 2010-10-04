class AddRouteIdToUnit < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.column :route_id, "int unsigned null"
      t.index :route_id
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end