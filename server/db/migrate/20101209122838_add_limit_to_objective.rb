class AddLimitToObjective < ActiveRecord::Migration
  def self.up
    change_table :objectives do |t|
      t.column :limit, "int(10) unsigned"
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end