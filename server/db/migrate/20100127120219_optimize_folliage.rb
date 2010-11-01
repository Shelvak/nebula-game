class OptimizeFolliage < ActiveRecord::Migration
  def self.up
    change_table :folliages do |t|
      %w{x y variation}.each do |attr|
        t.change attr, 'tinyint(2) unsigned not null', :default => false
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end