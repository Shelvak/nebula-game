class RemoveUnnecessaryIndexFromCallbacks < ActiveRecord::Migration
  def self.up
    # These two are duplicates of other indexes.
    remove_index :callbacks, :name => "time"
    remove_index :callbacks, :name => "removal"
  end

  def self.down
    raise IrreversibleMigration
  end
end