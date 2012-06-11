class ConvertTypesToEnum < ActiveRecord::Migration
  def self.up
    change_column :units, :type, enum_for_classes("unit"), null: false
    change_column :buildings, :type, enum_for_classes("building"), null: false
    change_column :technologies, :type, enum_for_classes("technology"),
      null: false
  end

  def self.down
    change_column :units, :type, :string, limit: 50, null: false
    change_column :buildings, :type, :string, limit: 50, null: false
    change_column :technologies, :type, :string, limit: 50, null: false
  end
end