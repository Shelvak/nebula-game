# Quest definition file.
#
# New quests can be added here but do not edit old ones!

# Please update this if you add new quests ;)
# Last quest id: 34
#

definition = QuestDefinition.define(:debug => false) do
  define(1, "Constructing Buildings") do
    have_upgraded_to Building::CollectorT1

    reward_cost Building::MetalExtractor, :count => 1.2
  end.define(2, "Extracting Metal") do
    have_upgraded_to Building::MetalExtractor

    reward_cost Building::MetalExtractor, :count => 1.1
    reward_cost Building::CollectorT1, :count => 1.1
  end.define(3) do
    have_upgraded_to Building::CollectorT1, :count => 2
    have_upgraded_to Building::MetalExtractor, :count => 2

    reward_cost Building::Barracks, :count => 1.2
  end.tap do |quest|
    # Side quest chain
    quest.define(22, "Exploring Objects") do
      explore_object Tile::FOLLIAGE_3X3

      reward_points 200
      reward_unit Unit::Gnat, :hp => 25
    end.define(23) do
      # 3x3 because we don't have a research center.
      explore_object Tile::FOLLIAGE_3X3, :count => 10

      reward_points 1000
      reward_unit Unit::Glancer, :hp => 60
    end

    # Side quest chain
    quest.define(4, "Upgrading Buildings") do
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

    reward_unit Unit::Trooper, :count => 4
    reward_cost Unit::Trooper, :count => 4.2
    reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
  end.define(7, "Building Units") do
    have_upgraded_to Unit::Trooper, :count => 8

    reward_cost Unit::Trooper, :count => 3.2
    reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
  end.define(8, "Attacking NPC Buildings") do
    destroy_npc_building Building::NpcMetalExtractor

    reward_unit Unit::Trooper, :level => 2, :hp => 50, :count => 2
    reward_unit Unit::Trooper, :level => 3, :hp => 30
    reward_cost Building::ResearchCenter, :count => 1.1
  end.tap do |quest|
    # Side quest chain
    quest.define(32) do
      have_upgraded_to Building::MetalExtractor, :count => 3, :level => 4

      reward_cost Building::MetalExtractor, :level => 4, :count => 1.2
      reward_points 2000
    end.define(9) do
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
  end.define(11) do
    have_upgraded_to Building::ResearchCenter

    reward_unit Unit::Trooper, :count => 4
    reward_unit Unit::Seeker, :count => 2
    reward_cost Unit::Trooper, :count => 8.2
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
    quest.define(12, "Researching Technologies") do
      have_upgraded_to Unit::Seeker, :count => 3

      reward_cost Technology::Seeker, :count => 0.7
      reward_cost Unit::Trooper, :count => 3
      reward_points 2000
    end.define(13) do
      have_upgraded_to Unit::Trooper, :count => 4, :level => 2
      
      reward_cost Technology::MetabolicChargers, :count => 0.95
      reward_points 2000
    end
  end.tap do |quest|
    quest.define(27, "Zetium Crystals") do
      destroy_npc_building Building::NpcZetiumExtractor

      reward_cost Technology::ZetiumExtraction, :count => 1.2
    end
  end.define(14) do
    have_upgraded_to Technology::ZetiumExtraction

    reward_cost Building::ZetiumExtractor, :count => 1.2
  end.define(15, "Extracting Zetium") do
    have_upgraded_to Building::ZetiumExtractor

    reward_cost Building::MetalStorage, :level => 1, :count => 1
    reward_cost Building::MetalStorage, :level => 2, :count => 1.2
    reward_cost Building::EnergyStorage, :level => 1, :count => 1.2
    reward_cost Building::ZetiumStorage, :level => 1, :count => 1.2
  end.tap do |quest|
    # Side quest
    quest.define(16, "Collecting Points") do
      have_points 15000

      reward_unit Unit::Trooper, :level => 3, :count => 1, :hp => 100
      reward_unit Unit::Seeker, :level => 2, :count => 1, :hp => 100
      reward_unit Unit::Shocker, :level => 1, :count => 3, :hp => 100
    end.define(28) do
      have_points 30000

      reward_unit Unit::Scorpion, :level => 2, :count => 2, :hp => 70
      reward_unit Unit::Azure, :level => 1, :count => 1, :hp => 100
    end.define(29) do
      have_points 60000

      reward_unit Unit::Cyrix, :level => 2, :count => 2, :hp => 60
      reward_unit Unit::Crow, :level => 1, :count => 4, :hp => 100
    end.define(30) do
      have_points 80000

      reward_unit Unit::Avenger, :level => 1, :count => 4, :hp => 100
      reward_unit Unit::Dart, :level => 1, :count => 4, :hp => 100
    end.define(33) do
      have_points 150000

      reward_unit Unit::Rhyno, :level => 1, :count => 1, :hp => 100
      reward_unit Unit::Cyrix, :level => 1, :count => 3, :hp => 100
    end
  end.define(17) do
    have_upgraded_to Building::MetalStorage, :level => 2
    have_upgraded_to Building::EnergyStorage, :level => 1
    have_upgraded_to Building::ZetiumStorage, :level => 1

    reward_cost Technology::SpaceFactory, :count => 1.2
  end.define(18) do
    have_upgraded_to Technology::SpaceFactory

    reward_cost Building::SpaceFactory, :count => 0.8
  end.define(19) do
    have_upgraded_to Building::SpaceFactory

    reward_unit Unit::Crow, :count => 4
    reward_cost Unit::Crow, :count => 4.2
  end.tap do |quest|
    quest.define(31, "Fighting in Space") do
      have_upgraded_to Unit::Crow, :count => 8

      reward_cost Unit::Crow, :count => 6
    end
  end.define(20, "Annexing Planets") do
    annex_planet :npc => true

    reward_unit Unit::Mule
    reward_unit Unit::Mdh
  end.define(21, "Colonizing Planets") do
    upgrade_to Building::Headquarters

    reward_metal Building::Headquarters.metal_storage(1) * 0.4
    reward_energy Building::Headquarters.energy_storage(1) * 0.4
    reward_zetium Building::Headquarters.zetium_storage(1) * 0.15
  end.define(34, "Exploring Galaxy") do
    have_upgraded_to Building::Radar

    reward_cost Building::Radar, :count => 0.8
    reward_energy Building::Radar.energy_usage_rate(1) * 2.days
  end
end

puts "Quests in definition: #{definition.count_in_definition}"
puts "Quests in database  : #{definition.count_in_db}"
puts "Added to database   : #{definition.count_in_definition -
  definition.count_in_db}"
puts "#{definition.quests_started_count} quests started for #{
  definition.quests_started_players} players."
