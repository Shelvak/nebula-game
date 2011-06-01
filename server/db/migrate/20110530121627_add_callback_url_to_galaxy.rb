class AddCallbackUrlToGalaxy < ActiveRecord::Migration
  def self.up
    add_column :galaxies, :callback_url, :string, :null => false, 
      :length => 50
    execute "UPDATE `galaxies` SET `callback_url`='nebula44.com'"
  end

  def self.down
    raise IrreversibleMigration
  end
end