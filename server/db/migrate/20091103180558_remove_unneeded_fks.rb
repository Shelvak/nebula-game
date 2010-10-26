class RemoveUnneededFks < ActiveRecord::Migration
  def self.up
    change_table :fow_planet_entries do |t|
      t.remove :galaxy_id
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end