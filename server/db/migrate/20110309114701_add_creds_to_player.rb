class AddCredsToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :creds, 'int unsigned not null', :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end