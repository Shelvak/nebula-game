class IndexTypeAndPlayerTechnologies < ActiveRecord::Migration
  def self.up
    add_index :technologies, [:player_id, :type, :level],
      :name => "type_by_player",
      :unique => true
  end

  def self.down
    raise IrreversibleMigration
  end
end