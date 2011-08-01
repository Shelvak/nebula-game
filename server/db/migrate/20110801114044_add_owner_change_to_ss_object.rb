class AddOwnerChangeToSsObject < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      t.datetime :owner_changed
    end
    
    execute "UPDATE ss_objects SET owner_changed=NOW() 
      WHERE type='Planet' AND player_id IS NOT NULL"
  end

  def self.down
    raise IrreversibleMigration
  end
end