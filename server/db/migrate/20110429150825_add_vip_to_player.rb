class AddVipToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :vip_level, 'tinyint(2) unsigned not null', :default => 0
      t.column :vip_creds, 'int unsigned not null', :default => 0
      t.datetime :vip_until
      t.datetime :vip_creds_until
    end

    change_table :cred_stats do |t|
      t.column :vip_level, 'tinyint(2) unsigned not null', :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end