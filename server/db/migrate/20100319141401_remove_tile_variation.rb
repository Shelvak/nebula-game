class RemoveTileVariation < ActiveRecord::Migration
  def self.up
    change_table :tiles do |t|
      t.remove :variation
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end