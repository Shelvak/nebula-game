class AddNpcFlagToObjective < ActiveRecord::Migration
  def self.up
    change_table :objectives do |t|
      t.boolean :npc, :null => false, :default => false
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end