class NewGalaxyGenerationStuff < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.remove :metal_rate, :energy_rate, :zetium_rate
    end
    
    remove_index :planets, :name => 'uniqueness'
    add_index :planets, [:solar_system_id, :position, :angle],
        :name => 'uniqueness', :unique => true

    change_table :folliages do |t|
      t.rename :variation, :kind
    end

    remove_column :tiles, :id
  end

  def self.down
    raise IrreversibleMigration
  end
end