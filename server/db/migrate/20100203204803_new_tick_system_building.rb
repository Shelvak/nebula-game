class NewTickSystemBuilding < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.remove :construction_started
      t.rename :construction_updated_at, :last_update
      t.rename :construction_ends, :upgrade_ends_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end