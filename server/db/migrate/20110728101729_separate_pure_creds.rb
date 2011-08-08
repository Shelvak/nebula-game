class SeparatePureCreds < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :pure_creds, 'int unsigned not null', :default => 0
    end
    
    Player.update_all "pure_creds=creds-vip_creds"
    
    remove_column :players, :creds
  end

  def self.down
    raise IrreversibleMigration
  end
end