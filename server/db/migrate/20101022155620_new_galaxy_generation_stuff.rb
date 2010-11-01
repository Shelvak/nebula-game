class NewGalaxyGenerationStuff < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.remove :metal_rate, :energy_rate, :zetium_rate
      t.change :name, :string, :limit => 20
      t.remove :variation
      t.column :terrain, "tinyint(2) unsigned not null", :default => 0
      %w{metal energy zetium}.each do |resource|
        ["", "_rate", "_storage"].each do |suffix|
          t.float "#{resource}#{suffix}", :null => false, :default => 0
        end
      end
      t.datetime :last_resources_update
      t.boolean :energy_diminish_registered, :default => false,
        :null => false
    end
    
    remove_index :planets, :name => 'uniqueness'
    add_index :planets, [:solar_system_id, :position, :angle],
        :name => 'uniqueness', :unique => true

    rename_table :planets, :ss_objects
    drop_table :resources_entries

    change_table :folliages do |t|
      t.rename :variation, :kind
    end

    remove_column :tiles, :id
  end

  def self.down
    raise IrreversibleMigration
  end
end