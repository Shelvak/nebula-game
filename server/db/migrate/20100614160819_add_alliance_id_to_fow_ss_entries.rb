class AddAllianceIdToFowSsEntries < ActiveRecord::Migration
  def self.up
    change_table :fow_ss_entries do |t|
      t.change :player_id, :integer, :null => true, :default => nil
      t.column :alliance_id, 'int unsigned null'
      t.remove_index :name => 'main'
      t.remove_index :name => 'index_fow_ss_entries_on_solar_system_id'

      t.index :player_id, :name => "select_by_player"
      t.index :alliance_id, :name => "select_by_alliance"
      t.index [:solar_system_id, :player_id], :name => "create_for_player",
        :unique => true
      t.index [:solar_system_id, :alliance_id],
        :name => "create_for_alliance",
        :unique => true
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end