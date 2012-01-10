class ChangeCombatLogStorageToBlob < ActiveRecord::Migration
  def self.up
    # Because Ruby migrations somehow fucking fails on Win32 by trying to
    # add a default column.
    execute("ALTER TABLE `combat_logs` CHANGE `info` `info` LONGBLOB NOT NULL")
    execute "ALTER TABLE `combat_logs` DROP PRIMARY KEY"
    add_index :combat_logs, :sha1_id, :unique => true, :name => :lookup
    add_column :combat_logs, :id, :primary_key

    log = CombatLog.new
    CombatLog.select("id, expires_at").c_select_all.each do |row|
      log.id = row['id']
      time = Time.parse(row['expires_at'])
      CallbackManager.register(log, CallbackManager::EVENT_DESTROY, time)
    end

    remove_column :combat_logs, :expires_at
  end

  def self.down
    raise IrreversibleMigration
  end
end