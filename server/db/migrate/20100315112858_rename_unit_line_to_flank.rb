class RenameUnitLineToFlank < ActiveRecord::Migration
  def self.up
    rename_column(:units, :line, :flank)
  end

  def self.down
    raise IrreversibleMigration
  end
end