class AddMoreCallbackIndexes < ActiveRecord::Migration
  def self.up
    change_table :callbacks do |t|
      t.index :ends_at, :name => "time"
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end