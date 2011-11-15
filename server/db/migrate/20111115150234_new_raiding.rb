class NewRaiding < ActiveRecord::Migration
  def self.up
    change_table :galaxies do |t|
      t.datetime :apocalypse_start
    end

    change_table :ss_objects do |t|
      t.column :raid_arg, 'tinyint(2) unsigned', :null => false, :default => 0
    end

    change_table :players do |t|
      t.column :bg_planets_count, 'tinyint(2) unsigned', :null => false,
               :default => 0
    end

    Player.find_each do |player|
      player.bg_planets_count = player.planets.accept do |planet|
        planet.solar_system.battleground?
      end.size
      player.save!

      player.planets.each do |planet|
        if planet.next_raid_at.nil?
          planet.next_raid_at = Time.now
          planet.raid_arg = 0
          spawner = RaidSpawner.new(planet)
          spawner.raid!
        else
          planet.raid_arg = planet.solar_system.battleground? \
            ? player.bg_planets_count : player.planets_count
        end
        planet.save!
      end
    end
  end

  def self.down
    remove_column :galaxies, :apocalypse_start
    remove_column :ss_objects, :raid_arg
    remove_column :players, :bg_planets_count
  end
end