class AddWorgToUnitEnum < ActiveRecord::Migration
  def self.up
    change_column :units, :type, enum_for_classes("unit"), null: false
  end

  def self.down
    raise IrreversibleMigration
  end
end