class AddUnitLine < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.column :line, 'tinyint(2) unsigned not null default 0'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end