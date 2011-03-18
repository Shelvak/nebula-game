class ChangeCombatLogInfoFieldType < ActiveRecord::Migration
  def self.up
    change_table :combat_logs do |t|
      t.change :info, 'MEDIUMTEXT NOT NULL'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end