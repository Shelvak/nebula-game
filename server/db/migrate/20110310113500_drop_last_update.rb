class DropLastUpdate < ActiveRecord::Migration
  def self.up
    remove_column :buildings, :last_update
    remove_column :units, :last_update
    remove_column :technologies, :last_update
  end

  def self.down
    raise IrreversibleMigration
  end
end