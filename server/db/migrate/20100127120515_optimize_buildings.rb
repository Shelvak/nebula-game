class OptimizeBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      %w{x y x_end y_end level}.each do |attr|
        t.change attr, 'tinyint(2) unsigned not null', :default => false
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end