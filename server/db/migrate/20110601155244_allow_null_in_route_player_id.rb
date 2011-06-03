class AllowNullInRoutePlayerId < ActiveRecord::Migration
  def self.up
    change_table :routes do |t|
      t.change :player_id, :int, :null => true
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end