class ChangeConfigIndex < ActiveRecord::Migration
  def self.up
    change_table :config_entries do |t|
      t.remove_index :name => :main
    end
    add_index :config_entries, :galaxy_id
  end

  def self.down
    raise IrreversibleMigration
  end
end