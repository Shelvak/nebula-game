class AddUniqueToTechnologies < ActiveRecord::Migration
  def self.up
    add_index :technologies, [:player_id, :type],
      :name => 'ensure_uniqueness', :unique => true
  end

  def self.down
    raise IrreversibleMigration
  end
end