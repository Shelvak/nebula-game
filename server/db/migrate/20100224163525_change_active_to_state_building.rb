class ChangeActiveToStateBuilding < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.rename :active, :state
      t.change :state, 'tinyint(2) not null', :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end