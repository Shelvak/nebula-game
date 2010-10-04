class RenameHpMod < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.rename :hp_mod, :armor_mod
      t.remove :hp_max
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end