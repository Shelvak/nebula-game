class RenamePlayerScientistsMax < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.rename :scientists_max, :scientists_total
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end