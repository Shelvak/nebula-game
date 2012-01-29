class AddAllianceCooldownIdToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :alliance_cooldown_id, :integer
    add_fk :alliances, :players, :target_key => :alliance_cooldown_id,
           :on_delete => "SET NULL"
  end

  def self.down
    remove_fk :players, :alliance_cooldown_id
    remove_column :players, :alliance_cooldown_id
  end
end