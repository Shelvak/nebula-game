class DropSidesFromTiles < ActiveRecord::Migration
  def self.up
    change_table :tiles do |t|
      t.remove :sides
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end