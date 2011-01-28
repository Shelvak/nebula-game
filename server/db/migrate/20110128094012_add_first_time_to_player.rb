class AddFirstTimeToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :first_time, :boolean, :default => true,
      :null => false
  end

  def self.down
    raise IrreversibleMigration
  end
end