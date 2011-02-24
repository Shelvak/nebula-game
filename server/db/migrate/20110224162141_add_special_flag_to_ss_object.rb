class AddSpecialFlagToSsObject < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      t.boolean :special, :null => false, :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end