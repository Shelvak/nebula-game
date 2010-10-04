class AddSidesToTiles < ActiveRecord::Migration
  def self.up
    change_table :tiles do |t|
      t.integer :sides, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end