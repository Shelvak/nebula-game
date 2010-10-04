class AddVariationToTile < ActiveRecord::Migration
  def self.up
    change_table :tiles do |t|
      t.column :variation, 'tinyint(2) unsigned'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end