class AddAllianceToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :alliance_id, 'int unsigned null'
      t.index :alliance_id
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end