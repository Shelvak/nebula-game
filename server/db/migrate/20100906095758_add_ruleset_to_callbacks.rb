class AddRulesetToCallbacks < ActiveRecord::Migration
  def self.up
    change_table :callbacks do |t|
      t.string :ruleset, :null => false, :limit => 30
    end

    change_table :galaxies do |t|
      t.change :ruleset, :string, :null => false, :limit => 30,
        :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end