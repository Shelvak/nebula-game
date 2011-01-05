# Quest definition file.
#
# New quests can be added here but do not edit old ones!

# Please update this if you add new quests ;)
# Last quest id: 26
#

definition = QuestDefinition.define(:debug => false) do
  define(1, "building") do
    have_upgraded_to Building::CollectorT1

    reward_cost Building::MetalExtractor, :count => 1.2
  end.define(2, "metal-extraction") do
    have_upgraded_to Building::MetalExtractor

    reward_cost Building::MetalExtractor, :count => 1.1
    reward_cost Building::CollectorT1, :count => 1.1
  end.define(3) do
    have_upgraded_to Building::CollectorT1, :count => 2
    have_upgraded_to Building::MetalExtractor, :count => 2

    reward_cost Building::Barracks, :count => 1.2
  end.tap do |quest|
    # Side quest chain
    quest.define(22, "exploring") do
      explore_object Tile::FOLLIAGE_3X3

      reward_points 200
      reward_unit Unit::Gnat, :hp => 25
    end.define(23) do
      explore_object Tile::FOLLIAGE_4X3, :count => 10

      reward_points 1000
      reward_unit Unit::Glancer, :hp => 60
    end

    # Side quest chain
    quest.define(4) do
      have_upgraded_to Building::CollectorT1, :count => 2, :level => 3
      have_upgraded_to Building::MetalExtractor, :count => 2, :level => 3

      reward_cost Building::CollectorT1, :count => 1.1, :level => 4
      reward_cost Building::MetalExtractor, :count => 1.1, :level => 4
    end.define(5) do
      have_upgraded_to Building::CollectorT1, :count => 2, :level => 4
      have_upgraded_to Building::MetalExtractor, :count => 2, :level => 4

      reward_metal Building::MetalExtractor.metal_rate(4) * 5.hours
      reward_zetium Building::ZetiumExtractor.zetium_rate(2) * 1.hour
      reward_points 4000
    end
  end.define(6) do
    have_upgraded_to Building::Barracks

    reward_unit Unit::Trooper, :count => 3
    reward_cost Unit::Trooper, :count => 3.2
    reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
  end.define(7, "building-units") do
    have_upgraded_to Unit::Trooper, :count => 6

    reward_cost Unit::Trooper, :count => 3.2
    reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
  end.define(8, "npc-buildings") do
    destroy_npc_building Building::NpcMetalExtractor

    reward_unit Unit::Trooper, :level => 2, :hp => 50, :count => 2
    reward_unit Unit::Trooper, :level => 3, :hp => 30
    reward_cost Building::ResearchCenter, :count => 1.1
  end.tap do |quest|
    # Side quest
    quest.define(9) do
      have_upgraded_to Building::MetalExtractor, :level => 7

      reward_cost Building::MetalExtractor, :level => 7, :count => 1.2
      reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
      reward_points 2000
    end
    # Side quest
    quest.define(10) do
      have_upgraded_to Building::CollectorT1, :level => 7

      reward_cost Building::CollectorT1, :level => 7, :count => 1.2
      reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
      reward_points 2000
    end
  end.define(11, "researching") do
    have_upgraded_to Building::ResearchCenter

    reward_cost Technology::ZetiumExtraction, :count => 1.2
  end.tap do |quest|
    # Side quest line
    quest.define(24) do
      explore_object Tile::FOLLIAGE_6X2, :count => 5

      reward_points 800
      reward_unit Unit::Gnat, :hp => 25, :count => 2
      reward_unit Unit::Gnat, :hp => 20, :count => 2
      reward_unit Unit::Gnat, :hp => 15, :count => 2
      reward_unit Unit::Gnat, :hp => 10, :count => 2
    end.define(25) do
      explore_object Tile::FOLLIAGE_4X4, :count => 5

      reward_points 800
      reward_unit Unit::Glancer, :hp => 80, :count => 2
    end.define(26) do
      explore_object Tile::FOLLIAGE_6X6, :count => 10

      reward_points 1600
      reward_unit Unit::Spudder, :hp => 96, :count => 1
    end

    # Side quest line
    quest.define(12) do
      have_upgraded_to Unit::Seeker, :count => 3

      reward_cost Technology::Seeker, :count => 0.7
      reward_cost Unit::Trooper, :count => 3
      reward_points 2000
    end.define(13) do
      have_upgraded_to Unit::Trooper, :count => 10
      
      reward_cost Technology::MetabolicChargers, :count => 0.8
      reward_points 2000
    end
  end.define(14) do
    have_upgraded_to Technology::ZetiumExtraction

    reward_cost Building::ZetiumExtractor, :count => 1.2
  end.define(15, "extracting-zetium") do
    have_upgraded_to Building::ZetiumExtractor

    reward_cost Building::EnergyStorage, :count => 0.8
    reward_cost Building::MetalStorage, :count => 0.8
    reward_cost Building::ZetiumStorage, :count => 0.8
  end.tap do |quest|
    # Side quest
    quest.define(16, "collecting-points") do
      have_points 20000

      reward_unit Unit::Trooper, :level => 3, :count => 1, :hp => 100
      reward_unit Unit::Seeker, :level => 2, :count => 1, :hp => 100
      reward_unit Unit::Shocker, :level => 1, :count => 3, :hp => 100
    end
  end.define(17, "storing-resources") do
    have_upgraded_to Building::EnergyStorage
    have_upgraded_to Building::MetalStorage
    have_upgraded_to Building::ZetiumStorage

    reward_cost Technology::SpaceFactory, :count => 0.8
  end.define(18, "research-space-factory") do
    have_upgraded_to Technology::SpaceFactory

    reward_cost Building::SpaceFactory, :count => 0.8
  end.define(19) do
    have_upgraded_to Building::SpaceFactory

    reward_unit Unit::Crow, :count => 2
  end.define(20, "annexing-planets") do
    annex_planet :npc => true

    reward_unit Unit::Mule
    reward_unit Unit::Mdh
  end.define(21, "colonizing") do
    upgrade_to Building::Headquarters

    reward_metal Building::Headquarters.metal_storage(1) * 0.4
    reward_energy Building::Headquarters.energy_storage(1) * 0.4
    reward_zetium Building::Headquarters.zetium_storage(1) * 0.15
  end
end

puts "Quests in definition: #{definition.count_in_definition}"
puts "Quests in database  : #{definition.count_in_db}"
puts "Added to database   : #{definition.count_in_definition -
  definition.count_in_db}"
puts "#{definition.quests_started_count} quests started for #{
  definition.quests_started_players} players."