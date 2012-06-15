class AddPoolConfigurationToGalaxy < ActiveRecord::Migration
  def self.up
    change_table :galaxies do |t|
      t.column :pool_free_zones, 'smallint(5) unsigned', null: false
      t.column :pool_free_home_ss, 'smallint(5) unsigned', null: false
    end
  end

  def self.down
    change_table :galaxies do |t|
      t.remove :pool_free_zones
      t.remove :pool_free_home_ss
    end
  end
end