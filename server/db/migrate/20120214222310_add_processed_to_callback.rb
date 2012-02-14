class AddProcessedToCallback < ActiveRecord::Migration
  def self.up
    rename_column :callbacks, :failed, :processing

    remove_index :callbacks, :name => :main
    add_index :callbacks, [:class, :object_id, :event, :processing],
      :name => :main, :unique => true
  end

  def self.down
    raise IrreversibleMigration
  end
end