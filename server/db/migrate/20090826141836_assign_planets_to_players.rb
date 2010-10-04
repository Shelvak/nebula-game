class AssignPlanetsToPlayers < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.belongs_to :player
    end

    add_index :planets, :player_id
  end

  def self.down
    raise IrreversibleMigration
  end
end