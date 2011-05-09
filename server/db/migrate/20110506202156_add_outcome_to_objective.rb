class AddOutcomeToObjective < ActiveRecord::Migration
  def self.up
    change_table :objectives do |t|
      t.column :outcome, "tinyint(2)"
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end