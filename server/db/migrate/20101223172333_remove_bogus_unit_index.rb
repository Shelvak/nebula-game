class RemoveBogusUnitIndex < ActiveRecord::Migration
  def self.up
    remove_index :units, :name => "group_by_for_fowssentry_status_updates"
  end

  def self.down
    raise IrreversibleMigration
  end
end