class AddLastLoginToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :last_login, :datetime, :null => true
    add_index :players, :last_login, :name => "last_login"
  end

  def self.down
    raise IrreversibleMigration
  end
end