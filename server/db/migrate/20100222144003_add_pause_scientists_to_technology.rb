class AddPauseScientistsToTechnology < ActiveRecord::Migration
  def self.up
    change_table :technologies do |t|
      t.change :scientists, 'int unsigned null default 0'
      t.column :pause_scientists, 'int unsigned null'
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end