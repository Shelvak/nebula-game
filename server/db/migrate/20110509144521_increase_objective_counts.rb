class IncreaseObjectiveCounts < ActiveRecord::Migration
  def self.up
    change_table :objectives do |t|
      t.change :count, "int unsigned not null", :default => 1
    end

    change_table :objective_progresses do |t|
      t.change :completed, "int unsigned not null", :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end