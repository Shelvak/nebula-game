class AddResourcesEntryCallbacks < ActiveRecord::Migration
  def self.up
    add_column :resources_entries, :energy_diminish_registered, :boolean,
      :null => false, :default => false
    add_index :callbacks, [:class, :object_id]
  end

  def self.down
    raise IrreversibleMigration
  end
end