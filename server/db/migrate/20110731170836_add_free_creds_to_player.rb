class AddFreeCredsToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :free_creds, "int unsigned not null", :default => 0
      t.boolean :vip_free, :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end