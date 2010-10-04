class UnitsTypeNotUniqueIndex < ActiveRecord::Migration
  def self.up
    begin
      remove_index :units, :name => 'type'
    rescue Exception
      # There was no index
    end
    add_index :units, [:player_id, :type], :name => 'type'
  end

  def self.down
    raise IrreversibleMigration
  end
end