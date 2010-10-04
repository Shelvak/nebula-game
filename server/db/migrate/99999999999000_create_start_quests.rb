class CreateStartQuests < ActiveRecord::Migration
  def self.up
    Quest.define(:resources) do
      # 1
      have_upgraded_to Building::MetalExtractor, :level => 1, :count => 1
      have_upgraded_to Building::SolarPlant, :level => 1, :count => 2

      reward_metal 100
      reward_energy 100
      reward_zetium 100
    end

    Quest.define(:army) do
      # 2
      have_upgraded_to Building::Barracks, :level => 1, :count => 1

      reward_unit Unit::Trooper, :level => 1, :count => 5
    end.define(:units) do
      # 3
      upgrade_to Unit::Trooper, :level => 1, :count => 3

      reward_metal 300
      reward_energy 500
      reward_zetium 400
    end.define(:units) do
      # 4
      upgrade_to(Unit::Shocker, :level => 1, :count => 2)

      reward_zetium 100
      reward_unit Unit::Shocker, :level => 3, :count => 3
      reward_unit Unit::Seeker, :level => 3, :count => 3
    end.tap do |quest|
      quest.define(:combat) do
        # 5
        destroy Unit::Gnat, :count => 10
        destroy Unit::Glancer, :count => 5

        reward_unit Unit::Scorpion, :level => 3, :count => 1
      end.define(:"ground-factory") do
        # 6
        have_upgraded_to Building::GroundFactory
        
        reward_unit Unit::Scorpion, :level => 1, :count => 2
      end.define(:"space-factory") do
        # 7
        have_upgraded_to Building::SpaceFactory
        
        reward_unit Unit::Crow, :level => 1, :count => 2
      end.define(:annexation) do
        # 8
        annex_planet :npc => true
        
        reward_metal 2000
        reward_energy 2000
        reward_zetium 1500
      end.define("enemy-annexation") do
        # 9
        annex_planet :npc => false

        reward_metal 2000
        reward_energy 2000
        reward_zetium 1500
        reward_xp 1000
        reward_points 2000
        reward_unit Unit::Cyrix, :level => 2, :count => 1
      end

      quest.define do
        # 10
        have_upgraded_to Unit::Trooper, :level => 1, :count => 10
        have_upgraded_to Unit::Shocker, :level => 1, :count => 5
        have_upgraded_to Unit::Seeker, :level => 1, :count => 5

        reward_zetium 1000
        reward_points 1000
        reward_xp 1000
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end