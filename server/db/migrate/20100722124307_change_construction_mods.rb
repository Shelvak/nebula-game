class ChangeConstructionMods < ActiveRecord::Migration
  def self.up
    rename_column(:buildings, :construction_mod, :constructor_mod)
    add_column :buildings, :construction_mod, 
      'tinyint(2) unsigned not null default 0'
    add_column :units, :construction_mod, 
      'tinyint(2) unsigned not null default 0'
  end

  def self.down
    raise IrreversibleMigration
  end
end