class AddDescriptionToAlliance < ActiveRecord::Migration
  def self.up
    change_table :alliances do |t|
      t.text :description, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end