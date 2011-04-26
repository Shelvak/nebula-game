class ChangeMaxAllianceNameLength < ActiveRecord::Migration
  def self.up
    change_table :alliances do |t|
      t.change(:name, :string, :null => false, :limit => 50)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end