# Quest definition file.
#
# New quests can be added here but do not edit old ones!

# Please update this if you add new quests ;)
# Last quest id: 121
#

# [unit, count, level]

UNITS_INFANTRY = [
  [Unit::Trooper, 2, 3],
  [Unit::Seeker, 1, 3],
  [Unit::Shocker, 1, 3],
  [Unit::Trooper, 2, 3],
  [Unit::Seeker, 1, 3],
  [Unit::Shocker, 1, 3],
]

UNITS_TANKS = [
  [Unit::Scorpion, 2, 3],
  [Unit::Avenger, 1, 3],
]

UNITS_SHIPS = [
  [Unit::Rhyno, 1, 3],
  [Unit::Cyrix, 3, 3],
  [Unit::Crow, 3, 2],
  [Unit::Dart, 1, 3], [Unit::Avenger, 1, 3],
  [Unit::Dart, 1, 3], [Unit::Avenger, 1, 3],
]

definition = QuestDefinition.define(:debug => false) do
  define(1, "buildings") do
    have_upgraded_to Building::CollectorT1

    reward_cost Building::MetalExtractor, :count => 1.2
  end.define(2, "metal") do
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
      # 3x3 because we don't have a research center.
      explore_object Tile::FOLLIAGE_3X3, :count => 10

      reward_points 1000
      reward_unit Unit::Glancer, :hp => 60
    end

    # Side quest chain
    quest.define(4, "upgrading") do
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
  end.tap do |quest|
    quest.define(7, "building-units") do
      have_upgraded_to Unit::Trooper, :count => 8

      reward_cost Unit::Trooper, :count => 3.2
      reward_zetium Building::ZetiumExtractor.zetium_rate(3) * 1.hour
    end.define_war_chain(80, 5, 2000, 1.4, UNITS_TANKS + UNITS_INFANTRY).  # Last quest ID is 84
      define_war_chain(85, 10, 10000, 1.37, UNITS_SHIPS + UNITS_TANKS). # Last quest ID is 94
      define_war_chain(106, 10, 200000, 1.15, UNITS_SHIPS)
      # Last quest ID is 115
  end.define(8, "attacking") do
    destroy_npc_building Building::NpcMetalExtractor

    reward_unit Unit::Trooper, :level => 2, :hp => 50, :count => 2
    reward_unit Unit::Trooper, :level => 3, :hp => 30
    reward_cost Building::ResearchCenter, :count => 1.1
    reward_creds (CONFIG['creds.vip'][0][0] * 1.5).ceil
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

    # VIP mode quest
    quest.define(116, "vip") do
      become_vip

      reward_creds CONFIG['creds.upgradable.speed_up'][-1][1]
    end.define(117, "accelerating") do
      accelerate Building

      reward_cost Unit::Shocker, :count => 3
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
    quest.define(12, "technologies") do
      have_upgraded_to Unit::Seeker, :count => 3

      reward_cost Technology::Seeker, :count => 0.7
      reward_cost Unit::Trooper, :count => 3
      reward_points 2000
    end.define(13) do
      have_upgraded_to Unit::Trooper, :count => 4, :level => 2
      
      reward_cost Technology::MetabolicChargers, :count => 0.95
      reward_points 2000
    end

    quest.define(72) do
      have_science_points 2500

      reward_scientists 10
    end.define(73) do
      have_science_points 5000

      reward_scientists 20
    end.define(74) do
      have_science_points 10000

      reward_scientists 30
    end.define(75) do
      have_science_points 25000

      reward_scientists 40
    end.define(76) do
      have_science_points 50000

      reward_scientists 60
    end.define(77) do
      have_science_points 100000

      reward_scientists 80
    end.define(78) do
      have_science_points 150000

      reward_scientists 100
    end.define(79) do
      have_science_points 200000

      reward_scientists 150
    end
    
    quest.define(118) do
      have_upgraded_to Technology::Market
      have_upgraded_to Building::Market
      
      reward_cost Technology::Market, :count => 1.1
      reward_cost Building::Market, :count => 2.5
    end
  end.tap do |quest|
    quest.define(27, "zetium") do
      destroy_npc_building Building::NpcZetiumExtractor

      reward_cost Technology::ZetiumExtraction, :count => 1.2
    end.define_army_chain(66, 4, 500, 1.7).
      define_army_chain(70, 2, 5000, 1.7).
      define_army_chain(95, 8, 15000, 1.4) # Last Quest ID is 102
  end.define(14) do
    have_upgraded_to Technology::ZetiumExtraction

    reward_cost Building::ZetiumExtractor, :count => 1.2
  end.define(15) do
    have_upgraded_to Building::ZetiumExtractor

    reward_cost Building::MetalStorage, :level => 1, :count => 1
    reward_cost Building::MetalStorage, :level => 2, :count => 1.2
    reward_cost Building::EnergyStorage, :level => 1, :count => 1.2
    reward_cost Building::ZetiumStorage, :level => 1, :count => 1.2
  end.tap do |quest|
    quest.define(121, "population") do
      have_upgraded_to Building::Housing
      
      reward_cost Building::Housing, :count => 0.65
    end
    
    # Side quest
    quest.define(16) do
      have_points 15000

      reward_unit Unit::Trooper, :level => 3, :count => 1, :hp => 100
      reward_unit Unit::Seeker, :level => 2, :count => 1, :hp => 100
      reward_unit Unit::Shocker, :level => 1, :count => 2, :hp => 100
    end.define(28) do
      have_points 30000

      reward_unit Unit::Scorpion, :level => 2, :count => 1, :hp => 70
      reward_unit Unit::Azure, :level => 1, :count => 1, :hp => 100
    end.define(29) do
      have_points 60000

      reward_unit Unit::Cyrix, :level => 2, :count => 1, :hp => 60
      reward_unit Unit::Crow, :level => 1, :count => 2, :hp => 100
    end.define(30) do
      have_points 80000

      reward_unit Unit::Avenger, :level => 1, :count => 1, :hp => 100
      reward_unit Unit::Dart, :level => 1, :count => 1, :hp => 100
    end.define(33) do
      have_points 150000

      reward_unit Unit::Rhyno, :level => 1, :count => 1, :hp => 100
      reward_unit Unit::Cyrix, :level => 3, :count => 2, :hp => 100
    end.define(64) do
      have_points 350000

      reward_unit Unit::Rhyno, :level => 7
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

    reward_unit Unit::Crow, :count => 2
    reward_cost Unit::Crow, :count => 4.2
  end.tap do |quest|
    quest.define(31) do
      have_upgraded_to Unit::Crow, :count => 5

      reward_cost Unit::Crow, :count => 7
    end.define(119, "flying") do
      destroy Unit::Dirac, :count => 4
      
      reward_cost Unit::Dirac, :count => 4
    end.tap do |quest1|
      quest1.define(120, "resource-transportation") do
        have_upgraded_to Unit::Mule, :count => 1

        reward_cost Unit::Mule, :count => 1.2
      end
      
      quest1.define(35) do
        destroy Unit::Dirac, :count => 14

        reward_unit Unit::Dart, :count => 2
      end.define(36) do
        destroy Unit::Thor, :count => 10

        reward_unit Unit::Avenger, :count => 2
      end.define(37) do
        destroy Unit::Demosis, :count => 6

        reward_unit Unit::Rhyno, :count => 1
      end
    end
  end.define(20, "colonization") do
    annex_planet

    reward_unit Unit::Mule
    reward_unit Unit::Mdh
  end.define(21) do
    upgrade_to Building::Headquarters

    reward_metal Building::Headquarters.metal_storage(1) * 0.4
    reward_energy Building::Headquarters.energy_storage(1) * 0.4
    reward_zetium Building::Headquarters.zetium_storage(1) * 0.15
  end.define(34, "radar") do
    have_upgraded_to Building::Radar

    reward_cost Building::Radar, :count => 0.8
    reward_energy Building::Radar.energy_usage_rate(1) * 2.days
  end.tap do |quest|
    quest.define(38) do
      have_planets :count => 3

      reward_unit Unit::Trooper, :level => 2, :count => 10
      reward_unit Unit::Seeker, :level => 2, :count => 5
      reward_unit Unit::Scorpion, :level => 2, :count => 2
    end.define(39) do
      have_planets :count => 4

      reward_unit Unit::Trooper, :level => 2, :count => 15
      reward_unit Unit::Shocker, :level => 2, :count => 8
      reward_unit Unit::Seeker, :level => 2, :count => 3
      reward_unit Unit::Scorpion, :level => 2, :count => 2
    end.define(40) do
      have_planets :count => 5

      reward_unit Unit::Shocker, :level => 2, :count => 8
      reward_unit Unit::Seeker, :level => 2, :count => 5
      reward_unit Unit::Scorpion, :level => 2, :count => 5
      reward_unit Unit::Azure, :level => 2, :count => 3
    end.define(41) do
      have_planets :count => 6

      reward_unit Unit::Shocker, :level => 2, :count => 10
      reward_unit Unit::Seeker, :level => 2, :count => 8
      reward_unit Unit::Scorpion, :level => 2, :count => 7
      reward_unit Unit::Azure, :level => 2, :count => 3
      reward_unit Unit::Cyrix, :level => 2, :count => 5
      reward_unit Unit::Dart, :level => 2, :count => 3
    end.define(42) do
      have_planets :count => 7

      reward_unit Unit::Shocker, :level => 2, :count => 15
      reward_unit Unit::Seeker, :level => 2, :count => 10
      reward_unit Unit::Scorpion, :level => 2, :count => 10
      reward_unit Unit::Azure, :level => 2, :count => 5
      reward_unit Unit::Cyrix, :level => 2, :count => 10
      reward_unit Unit::Avenger, :level => 2, :count => 5
      reward_unit Unit::Dart, :level => 2, :count => 5
    end

    quest.define(43) do
      destroy Unit::Mule, :count => 2

      reward_unit Unit::Mule, :level => 5
    end.define(44) do
      destroy Unit::Crow, :count => 6

      reward_unit Unit::Crow, :level => 5
    end.define(45) do
      destroy Unit::Cyrix, :count => 4

      reward_unit Unit::Cyrix, :level => 3
    end.define(46) do
      destroy Unit::Cyrix, :count => 10

      reward_unit Unit::Cyrix, :level => 5
    end.tap do |q|
      q.define(47) do
        destroy Unit::Avenger, :count => 6

        reward_unit Unit::Avenger, :level => 5
      end.define(48) do
        destroy Unit::Avenger, :count => 15

        reward_unit Unit::Avenger, :level => 5, :count => 3
      end

      q.define(49) do
        destroy Unit::Dart, :count => 6

        reward_unit Unit::Dart, :level => 5
      end.define(50) do
        destroy Unit::Dart, :count => 15

        reward_unit Unit::Dart, :level => 5, :count => 3
      end
    end.define(51) do
      destroy Unit::Rhyno, :count => 1

      reward_unit Unit::Avenger, :level => 8
    end.define(52) do
      destroy Unit::Rhyno, :count => 4

      reward_unit Unit::Rhyno, :level => 3
    end

    quest.define(53) do
      destroy Unit::Trooper, :count => 10
      destroy Unit::Shocker, :count => 5
      destroy Unit::Seeker, :count => 8

      reward_unit Unit::Scorpion, :level => 5
    end.define(54) do
      destroy Unit::Scorpion, :count => 15
      destroy Unit::Azure, :count => 5

      reward_unit Unit::Azure, :level => 6
    end.tap do |q2|
      q2.define(55) do
        destroy Building::Vulcan, :count => 2

        reward_unit Unit::Trooper, :level => 5, :count => 3
        reward_unit Unit::Seeker, :level => 5, :count => 3
        reward_unit Unit::Shocker, :level => 7
      end.define(56) do
        destroy Building::Vulcan, :count => 6

        reward_unit Unit::Trooper, :level => 5, :count => 4
        reward_unit Unit::Seeker, :level => 5, :count => 4
        reward_unit Unit::Shocker, :level => 7, :count => 2
      end.define(57) do
        destroy Building::Vulcan, :count => 10

        reward_unit Unit::Trooper, :level => 5, :count => 5
        reward_unit Unit::Seeker, :level => 5, :count => 5
        reward_unit Unit::Shocker, :level => 7, :count => 3
      end

      q2.define(58) do
        destroy Building::Screamer, :count => 2

        reward_unit Unit::Scorpion, :level => 6
        reward_unit Unit::Azure, :level => 6
      end.define(59) do
        destroy Building::Screamer, :count => 6

        reward_unit Unit::Scorpion, :level => 6, :count => 2
        reward_unit Unit::Azure, :level => 6, :count => 2
      end.define(60) do
        destroy Building::Screamer, :count => 10

        reward_unit Unit::Scorpion, :level => 6, :count => 3
        reward_unit Unit::Azure, :level => 6, :count => 3
      end

      q2.define(61) do
        destroy Building::Thunder, :count => 2

        reward_unit Unit::Cyrix, :count => 2, :level => 5
      end.define(62) do
        destroy Building::Thunder, :count => 6

        reward_unit Unit::Cyrix, :count => 4, :level => 5
      end.define(63) do
        destroy Building::Thunder, :count => 10

        reward_unit Unit::Cyrix, :count => 6, :level => 5
      end

      # Disabled for now because of changes in planets annexing. Needs
      # to be separated into other objective.
#      q2.define(65) do
#        annex_planet :npc => false
#
#        reward_unit Unit::Scorpion, :level => 5, :count => 2
#      end
    end
  end

  [50, 100, 250, 500, 1000, 2500].each_with_index do |count, index|
    achievement(10000 + index) { explore_any_object :count => count }
  end

  [100, 250, 500, 1000, 2500, 5000, 10000, 25000].each_with_index do
    |count, index|
    achievement(10020 + index) { destroy Unit, :count => count }
  end

  [10, 25, 50, 100, 250, 500].each_with_index do |count, index|
    achievement(10040 + index) { destroy Building, :count => count }
  end

  [5, 10, 25, 50, 75, 100].each_with_index do |count, index|
    achievement(10060 + index) { self_destruct :count => count }
  end

  [5, 10, 25, 50, 75, 100].each_with_index do |count, index|
    achievement(10080 + index) { accelerate_flight :count => count }
  end

  [100, 250, 500, 1000, 2500, 5000, 10000].each_with_index do
    |count, index|
    achievement(10100 + index) { upgrade_to Unit, :count => count }
  end

  [50, 100, 200, 500, 1000].each_with_index do |count, index|
    achievement(10120 + index) { upgrade_to Building, :count => count }
  end

  [5, 10, 15, 20, 25].each_with_index do |count, index|
    achievement(10140 + index) { have_upgraded_to Technology,
      :count => count }
  end

  [5, 15, 25, 50, 100, 150, 200].each_with_index do |count, index|
    achievement(10160 + index) { accelerate Unit, :count => count }
  end

  [5, 15, 25, 50, 100, 150, 200].each_with_index do |count, index|
    achievement(10180 + index) { accelerate Building, :count => count }
  end

  [5, 10, 15, 20, 25].each_with_index do |count, index|
    achievement(10200 + index) { accelerate Technology, :count => count }
  end

  [4, 8, 12, 16, 20].each_with_index do |count, index|
    achievement(10220 + index) { become_vip :count => count, :level => 1 }
  end

  [2, 4, 6, 8, 10].each_with_index do |count, index|
    achievement(10240 + index) { become_vip :count => count, :level => 2 }
  end

  [1, 2, 3, 4, 5].each_with_index do |count, index|
    achievement(10260 + index) { become_vip :count => count, :level => 3 }
  end

  [1, 2, 3, 4, 5].each_with_index do |count, index|
    achievement(10280 + index) { upgrade_to Building::Radar, :count => count }
  end

  [1, 2, 3].each_with_index do |count, index|
    achievement(10290 + index) { upgrade_to Building::Radar,
      :count => count, :level => 2 }
  end

  [25, 50, 100].each_with_index do |count, index|
    achievement(10300 + index) { complete_quests :count => count }
  end

  [25, 50, 100].each_with_index do |count, index|
    achievement(10320 + index) { complete_achievements :count => count }
  end

  [50, 100, 150, 200, 500].each_with_index do |count, index|
    achievement(10340 + index) { battle Combat::OUTCOME_WIN, :count => count }
  end

  [50, 100, 150, 200, 500].each_with_index do |count, index|
    achievement(10360 + index) { battle Combat::OUTCOME_LOSE, :count => count }
  end

  [5, 10, 25, 50, 75, 100].each_with_index do |count, index|
    achievement(10380 + index) { move_building :count => count }
  end

  [
    25000, 50000, 100000, 250000, 500000, 1000000, 2000000
  ].each_with_index do |count, index|
    achievement(10400 + index) { heal_hp count }
  end
end

puts "Quests in definition: #{definition.count_in_definition}"
puts "Quests in database  : #{definition.count_in_db}"
puts "Added to database   : #{definition.count_in_definition -
  definition.count_in_db}"
puts "#{definition.quests_started_count} quests started for #{
  definition.quests_started_players} players."
