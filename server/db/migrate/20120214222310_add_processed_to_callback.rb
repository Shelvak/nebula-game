class AddProcessedToCallback < ActiveRecord::Migration
  def self.up
    rename_column :callbacks, :failed, :processing
  end

  def self.down
    raise IrreversibleMigration
  end
end