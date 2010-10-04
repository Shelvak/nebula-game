class ChangePlanetIndexes < ActiveRecord::Migration
  def self.up
    remove_index :planets, :player_id
    add_index :planets, [:player_id, :galaxy_id]
  end

  def self.down
    raise IrreversibleMigration
  end
end