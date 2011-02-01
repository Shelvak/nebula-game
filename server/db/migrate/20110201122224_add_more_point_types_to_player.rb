class AddMorePointTypesToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.rename :points, :war_points
      t.column :army_points, "int unsigned not null", :default => 0
      t.column :science_points, "int unsigned not null", :default => 0
      t.column :economy_points, "int unsigned not null", :default => 0
      t.column :planets_count, "tinyint(2) unsigned not null"
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end