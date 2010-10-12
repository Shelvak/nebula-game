class AddUnitLine < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.column :line, 'tinyint(2) unsigned', :default => 0, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end