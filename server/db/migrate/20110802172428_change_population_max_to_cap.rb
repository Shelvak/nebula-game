class ChangePopulationMaxToCap < ActiveRecord::Migration
  def self.up
    rename_column :players, :population_max, :population_cap
  end

  def self.down
    raise IrreversibleMigration
  end
end