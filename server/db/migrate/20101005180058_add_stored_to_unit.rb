class AddStoredToUnit < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      t.column :stored, 'int unsigned not null default 0'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end