class ChangeCombatLogInfoFieldType < ActiveRecord::Migration
  def self.up
    # Because Ruby migrations somehow fucking fails on Win32 by trying to
    # add a default column.
    connection.execute(
      "ALTER TABLE `combat_logs` CHANGE `info` `info` MEDIUMTEXT NOT NULL"
    )
  end

  def self.down
    raise IrreversibleMigration
  end
end