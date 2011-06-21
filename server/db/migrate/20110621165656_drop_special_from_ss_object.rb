class DropSpecialFromSsObject < ActiveRecord::Migration
  def self.up
    remove_column :ss_objects, :special
  end

  def self.down
    raise IrreversibleMigration
  end
end