class ChangeAuthScheme < ActiveRecord::Migration
  def self.up
    connection.execute("UPDATE players SET auth_token=id")
    add_index :players, :galaxy_id, :name => :temp
    remove_index :players, :name => :authentication

    change_table :players do |t|
      t.rename :auth_token, :web_user_id
      t.change :web_user_id, 'int(10) unsigned', :null => false
      t.change :galaxy_id, :integer, :null => false
    end

    add_index :players, [:galaxy_id, :web_user_id], :name => :authentication,
              :unique => true
    remove_index :players, :name => :temp
  end

  def self.down
    raise IrreversibleMigration
  end
end