class AddLocationCoordsToUnit < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.column :location_x, 'mediumint'
      t.column :location_y, 'mediumint'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end