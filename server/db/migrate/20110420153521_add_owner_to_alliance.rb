class AddOwnerToAlliance < ActiveRecord::Migration
  def self.up
    change_table :alliances do |t|
      t.belongs_to :owner, :null => false
    end

    add_fk("players", "alliances", :target_key => "owner_id",
           :on_delete => "NO ACTION")
  end

  def self.down
    raise IrreversibleMigration
  end
end