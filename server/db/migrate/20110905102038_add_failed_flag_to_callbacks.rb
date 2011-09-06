class AddFailedFlagToCallbacks < ActiveRecord::Migration
  def self.up
    add_column :callbacks, :failed, :boolean, :null => false, 
      :default => false
    remove_index :callbacks, :name => :tick
    add_index :callbacks, [:ends_at, :failed], :name => :tick
  end

  def self.down
    raise IrreversibleMigration
  end
end