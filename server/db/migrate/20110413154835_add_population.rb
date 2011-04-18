class AddPopulation < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :population, 'mediumint unsigned not null', :default => 0
      t.column :population_max, 'mediumint unsigned not null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end