class RenameSsShieldOwnerIdToPlayerId < ActiveRecord::Migration
  def self.up
    remove_fk :solar_systems, :shield_owner_id
    change_table :solar_systems do |t|
      t.rename :shield_owner_id, :player_id
    end
    add_fk :players, :solar_systems
  end

  def self.down
    remove_fk :solar_systems, :player_id
    change_table :solar_systems do |t|
      t.rename :player_id, :shield_owner_id
    end
    add_fk :players, :solar_systems, :target_key => :shield_owner_id
  end
end