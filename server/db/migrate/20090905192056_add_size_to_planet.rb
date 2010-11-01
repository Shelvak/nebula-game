class AddSizeToPlanet < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.string :size, :null => false, :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end