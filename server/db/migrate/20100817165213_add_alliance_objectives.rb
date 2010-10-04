class AddAllianceObjectives < ActiveRecord::Migration
  def self.up
    change_table :objectives do |t|
      t.boolean :alliance, :null => false, :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end