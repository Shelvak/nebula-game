class AddRulesetToGalaxy < ActiveRecord::Migration
  def self.up
    change_table :galaxies do |t|
      t.string :ruleset, :null => false, :default => GameConfig::DEFAULT_SET
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end