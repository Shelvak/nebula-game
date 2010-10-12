class OptimizeTile < ActiveRecord::Migration
  def self.up
    change_table :tiles do |t|
      %w{x y kind}.each do |attr|
        t.change attr, 'tinyint(2) unsigned not null', :default => false
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end