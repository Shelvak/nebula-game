class AddStanceToUnit < ActiveRecord::Migration
  def self.up
    add_column :units, :stance, 'tinyint(2) unsigned not null DEFAULT 0'
  end

  def self.down
    raise IrreversibleMigration
  end
end