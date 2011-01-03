# Quest definition file.
#
# New quests can be added here but do not edit old ones!

# Please update this if you add new quests ;)
# Last quest id: 19
#

definition = QuestDefinition.define do
  define(1, "building") do
    have_upgraded_to Building::CollectorT1
    reward_metal 1000
    reward_energy 1000
  end.define(2, "metal-extraction") do
    have_upgraded_to Building::MetalExtractor
    reward_metal 1000
    reward_energy 1000
  end.define(3) do
    have_upgraded_to Building::CollectorT1, :count => 2
    have_upgraded_to Building::MetalExtractor, :count => 2
    reward_metal 1000
    reward_energy 1000
  end.tap do |quest|
    # Side quest
    quest.define(4) do
      have_upgraded_to Building::CollectorT1, :count => 2, :level => 3
      have_upgraded_to Building::MetalExtractor, :count => 2, :level => 3
      reward_metal 1000
      reward_energy 1000
    end.define(5) do
      have_upgraded_to Building::CollectorT1, :count => 2, :level => 4
      have_upgraded_to Building::MetalExtractor, :count => 2, :level => 4
      reward_metal 1000
      reward_energy 1000
    end
  end.define(6) do
    have_upgraded_to Building::Barracks
    reward_metal 1500
    reward_energy 1500
  end.define(7, "building-units") do
    have_upgraded_to Unit::Trooper, :count => 2
    reward_metal 1000
    reward_energy 1000
  end.define(8) do
    destroy_npc_building Building::NpcMetalExtractor
    reward_unit Unit::Trooper, :level => 2, :hp => 50
    reward_unit Unit::Trooper, :level => 3, :hp => 20
  end.tap do |quest|
    # Side quest
    quest.define(9) do
      have_upgraded_to Building::MetalExtractor, :level => 7
      reward_metal 1000
      reward_energy 1000
    end
    # Side quest
    quest.define(10) do
      have_upgraded_to Building::CollectorT1, :level => 7
      reward_metal 1000
      reward_energy 1000
    end
  end.define(11, "researching") do
    have_upgraded_to Building::ResearchCenter
    reward_metal 2000
    reward_energy 2000
    reward_zetium 600
  end.tap do |quest|
    # Side quest line
    quest.define(12) do
      have_upgraded_to Unit::Seeker, :count => 3
      reward_metal 1000
      reward_energy 1000
      reward_zetium 100
    end.define(13) do
      have_upgraded_to Unit::Trooper, :count => 5
      reward_metal 1000
      reward_energy 1000
      reward_zetium 100
    end
  end.define(14) do
    have_upgraded_to Technology::ZetiumExtraction
    reward_metal 1000
    reward_energy 1000
    reward_zetium 200
  end.define(15, "extracting-zetium") do
    have_upgraded_to Building::ZetiumExtractor
    reward_metal 1000
    reward_energy 1000
    reward_zetium 200
  end.tap do |quest|
    # Side quest
    quest.define(16, "collecting-points") do
      have_points 3000
      reward_unit Unit::Seeker, :level => 2, :count => 2, :hp => 100
      reward_unit Unit::Shocker, :level => 2, :count => 2, :hp => 100
    end
  end.define(17, "storing-resources") do
    have_upgraded_to Building::EnergyStorage
    have_upgraded_to Building::MetalStorage
    have_upgraded_to Building::ZetiumStorage

    reward_metal 4000
    reward_energy 4000
    reward_zetium 2000
  end.define(18, "space-factory") do
    have_upgraded_to Technology::SpaceFactory
    reward_metal 4000
    reward_energy 4000
    reward_zetium 2000
  end.define(19) do
    have_upgraded_to Building::SpaceFactory
    reward_metal 4000
    reward_energy 4000
    reward_zetium 2000
  end
end

puts "Quests in definition: #{definition.count_in_definition}"
puts "Quests in database  : #{definition.count_in_db}"
puts "Added to database   : #{definition.count_in_definition -
  definition.count_in_db}"
puts "#{definition.quests_started_count} quests started for #{
  definition.quests_started_players} players."