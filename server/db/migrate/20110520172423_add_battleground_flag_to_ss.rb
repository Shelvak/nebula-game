class AddBattlegroundFlagToSs < ActiveRecord::Migration
  def self.up
    change_table :solar_systems do |t|
      t.rename :wormhole, :kind
      t.change :kind, "tinyint(2) not null",
               :default => SolarSystem::KIND_NORMAL
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end