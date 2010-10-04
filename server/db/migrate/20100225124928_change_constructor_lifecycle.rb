class ChangeConstructorLifecycle < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.remove :currently_constructing, :constructing_max, :constructor_id
      t.string :constructable_type, :limit => 100
      t.integer :constructable_id
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end