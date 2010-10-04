class AddUnitType < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.string :type, :limit => 50, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end