class AddXpToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :xp, 'int unsigned not null default 0'
      t.column :points, 'int unsigned not null default 0'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end