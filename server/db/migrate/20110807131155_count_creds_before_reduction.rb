class CountCredsBeforeReduction < ActiveRecord::Migration
  def self.up
    change_table :cred_stats do |t|
      t.rename :creds_left, :creds
      t.rename :attribute, :attr
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end