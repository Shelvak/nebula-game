class AddTypeToCallbacks < ActiveRecord::Migration
  def self.up
    change_table :callbacks do |t|
      t.column :event, 'tinyint(2) unsigned not null default 0'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end