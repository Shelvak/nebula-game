class AddParamsToUpgradeQueue < ActiveRecord::Migration
  def self.up
    change_table :upgrade_queue_entries do |t|
      t.text :params
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end