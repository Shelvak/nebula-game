class CreateResourcesEntry < ActiveRecord::Migration
  def self.up
    create_table :resources_entries, :primary_key => :planet_id do |t|
      t.integer :metal, :metal_storage, :energy, :energy_storage,
        :zetium, :zetium_storage, :metal_rate, :energy_rate, :zetium_rate,
        :null => false, :default => 0
      t.datetime :last_update
    end

    add_index :resources_entries, :last_update
  end

  def self.down
    drop_table :resources_entries
  end
end