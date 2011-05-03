class AddVipCredsToStats < ActiveRecord::Migration
  def self.up
    change_table :cred_stats do |t|
      t.column :vip_creds, 'int unsigned not null', :default => 0
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end