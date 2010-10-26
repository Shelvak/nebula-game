class AddCacheToGalaxyObjects < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.belongs_to :galaxy, :null => false
    end

    add_index :planets, [:galaxy_id, :solar_system_id]
  end

  def self.down
    raise IrreversibleMigration
  end
end