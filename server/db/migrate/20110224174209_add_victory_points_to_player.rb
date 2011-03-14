class AddVictoryPointsToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :victory_points, 'mediumint unsigned not null', :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end