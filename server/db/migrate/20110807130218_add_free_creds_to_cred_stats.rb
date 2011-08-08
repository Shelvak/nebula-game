class AddFreeCredsToCredStats < ActiveRecord::Migration
  def self.up
    change_table :cred_stats do |t|
      t.column :free_creds, 'int unsigned not null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end