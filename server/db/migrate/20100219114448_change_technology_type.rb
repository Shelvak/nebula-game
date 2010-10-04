class ChangeTechnologyType < ActiveRecord::Migration
  def self.up
    change_table :technologies do |t|
      t.change :type, :string, :limit => 50, :null => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end