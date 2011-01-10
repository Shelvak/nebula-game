class AddSpeedUpToTechnology < ActiveRecord::Migration
  def self.up
    add_column :technologies, :speed_up, :boolean, :default => 0,
      :null => false
  end

  def self.down
    raise IrreversibleMigration
  end
end