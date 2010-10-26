class ChangeSizeTypeInPlanet < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.change :size, :integer, :null => false, :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end