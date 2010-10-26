class AddMetadataToFowSsEntries < ActiveRecord::Migration
  def self.up
    change_table :fow_ss_entries do |t|
      t.boolean :player_planets, :player_ships, :enemy_planets, :enemy_ships, :alliance_planets,
        :alliance_ships,
        :null => false, :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end