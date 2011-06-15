class AddAllianceVpsToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :alliance_vps, "int unsigned not null", :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
