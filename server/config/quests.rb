# Quest definition file.
#
# New quests can be added here but do not edit old ones!

# Please update this if you add new quests ;)
# Last quest id: 133
#

# Tutorial screens:
# Quest screen.
s_quest = "Quest"
# Shows quest screen with image.
s_quest_with_image = lambda { |klass| "QuestWithImage:#{klass.to_s}" }
# Explains about building sidebar.
s_building_sidebar = "BuildingSidebar"
# Explains claiming rewards for completed quests.
s_claim_reward = "ClaimReward"
# Explains about ore tiles.
s_ore_tile = "OreTile"
# Explains about building upgrades.
s_building_upgrade = "BuildingUpgrade"
# Explains about +energy tiles.
s_energy_tiles = "EnergyTiles"
# Explains about +construction tiles.
s_construction_tiles = "ConstructionTiles"
# Explains about speeding up constructions.
s_speedup_construction = "SpeedupConstruction"
# Explains about unit constructors
s_unit_constructors = "UnitConstructors"
# Explains about unit construction screen.
s_unit_construction_screen = "UnitConstructionScreen"
# Previous quest has given you units as a reward. Claim them.
s_take_units_reward = "TakeUnitsReward"
# Explains about unit screen. Where to find it and what's in it.
s_unit_screen = "UnitScreen"
# Explains about attack button.
s_attack_button = "AttackButton"
# Explains about attack screen.
s_attack_screen = "AttackScreen"
# Explains about damaged units and their healing (that it will be available
# later and you need to research it).
s_damaged_units = "DamagedUnits"
# Explains about exploring.
s_exploring = "Exploring"
# Explains about notifications.
s_notifications = "Notifications"
# Explains about technology tree.
s_tech_tree = "TechTree"
# Explains about researching technologies.
s_tech_research = "TechResearch"
# Explains about war points importance in technologies.
s_wp_in_techs = "WPInTechs"
# Explains about zetium tile.
s_zetium_tile = "ZetiumTile"
# Explains about NPC zetium extractor (if you haven't destroyed it yet).
s_npc_zex = "NPCZex"
# Explains about planet resources & storage types.
s_resources = "Resources"
# Explains about resource bar at the bottom of the screen.
s_resource_bar = "ResourceBar"
# Explains about the market screen.
s_market = "Market"
# Explains population and overpopulation.
s_population = "Population"
# Explains about unit screen when space units are present.
s_unit_screen_with_space = "UnitScreenWithSpace"
# Explains how to send your unit above your planet.
s_sending_ships = "SendingShips"
# Explains about combat in space sector.
s_combat_in_space = "CombatInSpace"
# Explains how to send units from space to planet.
s_move_to_planet = "MoveToPlanet"
# Explains how to take over a planet and that all buildings will be transferred
# to player.
s_claim_planet = "ClaimPlanet"
# Explains about wreckage.
s_wreckage = "Wreckage"
# Explains how to load wreckage into mule when it is above wreckage:
# Press show, press load on mule, press load all/tune sliders, confirm, close.
s_load_wreckage = "LoadWreckage"
# Explains how to unload wreckage in planet:
# Press units, press unload, press unload all/tune sliders, confirm, close.
s_unload_resources = "UnloadResources"
# Explains what radar does.
s_radar = "Radar"
# Explains how to load units. Explain that we need MDH & ground units to attack
# third planet.
s_load_units = "LoadUnits"
# Explains how to unload units.
s_unload_units = "UnloadUnits"
# Explains how to deploy units.
s_deploy_units = "DeployUnits"
# Explains about third planet.
s_3rd_planet = "3rdPlanet"
# Explains about armor tiles.
s_armor_tiles = "ArmorTiles"
# Explains about raiders.
s_raiders = "Raiders"
# Explains about economy tier 2: required technologies, how to destroy old
# extractors and build new ones in their places.
s_eco_tier2 = "EcoTier2"
# Explains how to join an alliance.
s_join_alliance = "JoinAlliance"
# Explains how to create alliance.
s_create_alliance = "CreateAlliance"
# Explains how to invite to alliance.
s_invite_to_alliance = "InviteToAlliance"
# Explains about battleground planets.
s_bg_planets = "BgPlanets"
# Explains about boss ship in battleground.
s_boss_ship = "BossShip"
# Explains about pulsars.
s_pulsars = "Pulsars"
# Explains about convoys.
s_convoys = "Convoys"
# Explains about galaxy battles.
s_galaxy_battles = "GalaxyBattles"

mex_1st_planet = 7
mex_2nd_planet = 8
mex_3rd_planet = 4
energy_1st_planet = 8
energy_2nd_planet = 8
energy_3rd_planet = 6
zex_1st_planet = 2
zex_2nd_planet = 4
zex_3rd_planet = 2

QUESTS = QuestDefinition.define(:debug => false) do
  # Main quests  - they have IDs of     1 - 10000
  #                and are spaced by 10 to allow insertion.                     ###
  #                Last id: 340
  # Side quests  - they have IDs of 10001 - 20000
  #                last id: 1
  # Achievements - they have IDs of 20001 - 30000

  define(10, [s_quest_with_image[Building::CollectorT1], s_building_sidebar]) do
    have_upgraded_to Building::CollectorT1

    reward_cost Building::MetalExtractor, :count => 1.2
  end.define(20, [s_claim_reward, s_quest_with_image[Building::MetalExtractor],
                 s_ore_tile]) do
    have_upgraded_to Building::MetalExtractor

    reward_cost Building::MetalExtractor, :count => 1.1
    reward_cost Building::CollectorT1, :count => 1.1
  end.define(30, [s_quest, s_building_upgrade]) do
    have_upgraded_to Building::CollectorT1, :level => 2
    have_upgraded_to Building::MetalExtractor, :level => 2

    reward_cost Building::MetalExtractor, :count => 1.1
    reward_cost Building::CollectorT1, :count => 4.2
  end.define(40, [s_quest, s_energy_tiles]) do
    have_upgraded_to Building::MetalExtractor, :count => 2, :level => 2
    have_upgraded_to Building::CollectorT1, :count => 4, :level => 2

    reward_cost Building::Barracks, :count => 1.2
    # 200 creds are enough for the speeding up of barracks construction.
    reward_creds 200
  end.define(50, [s_quest_with_image[Building::Barracks], s_construction_tiles,
                 s_speedup_construction]) do
    have_upgraded_to Building::Barracks

    reward_cost Unit::Trooper, :count => 1.2
  end.define(60, [s_quest_with_image[Unit::Trooper], s_unit_constructors,
                 s_unit_construction_screen]) do
    have_upgraded_to Unit::Trooper

    reward_unit Unit::Trooper, :count => 5
  end.tap do |quest|
    quest.define(10010) do
      destroy_npc_building Building::NpcMetalExtractor

      reward_cost Building::MetalExtractor, :count => 2, :level => 4
    end

    # Economy points side chain
    quest.define_eco_chain(10020, 5,    2000, 1.4 ). # Last quest ID is 10024
          define_eco_chain(10040, 10,  10000, 1.37). # Last quest ID is 10049
          define_eco_chain(10060, 10, 200000, 1.15)  # Last quest ID is 10069

    # War points side chain
    quest.define_war_chain(10100,  5,   2000, 1.4 ). # Last quest ID is 10104
          define_war_chain(10120, 10,  10000, 1.37). # Last quest ID is 10129
          define_war_chain(10140, 10, 200000, 1.15)  # Last quest ID is 10149

    # General points side quest chain
    quest.define(10160) do
      have_points 15000

      reward_unit Unit::Trooper, :level => 5, :count => 2
      reward_unit Unit::Seeker, :level => 3, :count => 1
      reward_unit Unit::Shocker, :level => 3, :count => 1
    end.define(10170) do
      have_points 30000

      reward_unit Unit::Scorpion, :level => 4, :count => 2
      reward_unit Unit::Azure, :level => 4, :count => 1
    end.define(10180) do
      have_points 60000

      reward_unit Unit::Crow, :level => 5, :count => 5
    end.define(10190) do
      have_points 80000

      reward_unit Unit::Avenger, :level => 5, :count => 3
      reward_unit Unit::Dart, :level => 5, :count => 3
    end.define(10200) do
      have_points 150000

      reward_unit Unit::Rhyno, :level => 3, :count => 1
    end.define(10210) do
      have_points 350000

      reward_unit Unit::Rhyno, :level => 10, :count => 1
    end
  end.define(70, [s_take_units_reward, s_unit_screen,
                 s_quest_with_image[Building::NpcSolarPlant], s_attack_button,
                 s_attack_screen]) do
    destroy_npc_building Building::NpcSolarPlant, :count => 5

    reward_cost Building::ResearchCenter
    # 1000 creds should be sufficient for completing research center.
    reward_creds 1000
  end.define(80, [s_damaged_units,
                 s_quest_with_image[Building::ResearchCenter]]) do
    have_upgraded_to Building::ResearchCenter

    reward_scientists 18
  end.tap do |quest|
    # Science points side chain
    quest.
      define(10220) { have_science_points     2_500; reward_scientists  10 }.
      define(10225) { have_science_points     5_000; reward_scientists  20 }.
      define(10230) { have_science_points    10_000; reward_scientists  30 }.
      define(10235) { have_science_points    25_000; reward_scientists  40 }.
      define(10240) { have_science_points    50_000; reward_scientists  60 }.
      define(10245) { have_science_points   100_000; reward_scientists  80 }.
      define(10250) { have_science_points   150_000; reward_scientists 100 }.
      define(10255) { have_science_points   200_000; reward_scientists 150 }.
      define(10260) { have_science_points   300_000; reward_scientists 200 }.
      define(10265) { have_science_points   400_000; reward_scientists 250 }.
      define(10270) { have_science_points   500_000; reward_scientists 300 }.
      define(10275) { have_science_points   750_000; reward_scientists 400 }.
      define(10280) { have_science_points 1_000_000; reward_scientists 500 }.
      define(10285) { have_science_points 1_500_000; reward_scientists 600 }.
      define(10290) { have_science_points 2_000_000; reward_scientists 700 }

    # Technologies side quest line
    tech_side = [
      [10300, Technology::Trooper,                  3, 0.7 ],
      [10305, Technology::Seeker,                   2, 0.65],
      [10310, Technology::Shocker,                  2, 0.6 ],
      [10315, Technology::FieryMelters,             3, 0.55],
      [10320, Technology::SuperconductorTechnology, 3, 0.5 ],
      [10325, Technology::PowderedZetium,           3, 0.45],
      [10330, Technology::Vulcan,                   3, 0.4 ],
      [10335, Technology::Screamer,                 3, 0.35],
      [10340, Technology::Thunder,                  3, 0.3 ],
      [10345, Technology::ShipStorage,              3, 0.25],
      [10350, Technology::HeavyFlight,              3, 0.2 ],
      [10355, Technology::DefensivePortal,          1, nil ],
    ]

    q = quest
    tech_side.each_with_index do
      |(id, technology, level, next_reward_multiplier), index|

      q = q.define(id) do
        have_upgraded_to technology, :level => level
        if index == tech_side.size - 1
          # Last item
          reward_creds 2500
        else
          reward_cost tech_side[index + 1][1], :count => next_reward_multiplier
        end
      end
    end
  end.define(90, [s_quest, s_exploring, s_notifications]) do
    explore_object Tile::FOLLIAGE_3X3

    reward_unit Unit::Gnat, :count => 5
    reward_unit Unit::Glancer, :count => 2
    reward_cost Technology::ZetiumExtraction, :count => 0.95
  end.tap do |quest|
    # Exploration side quest chain
    [
      [10400, Tile::FOLLIAGE_3X3,  5, Unit::Gnat,    5,  5],
      [10405, Tile::FOLLIAGE_3X3, 10, Unit::Gnat,    5, 10],
      [10410, Tile::FOLLIAGE_6X2, 10, Unit::Glancer, 5,  5],
      [10415, Tile::FOLLIAGE_4X4, 10, Unit::Glancer, 5, 10],
      [10420, Tile::FOLLIAGE_6X6,  5, Unit::Spudder, 5,  5],
      [10425, Tile::FOLLIAGE_6X6, 10, Unit::Spudder, 5, 10],
    ].inject(quest) do
      |q, (id, tile, exploration_count, unit, unit_count, unit_level)|

      q.define(id) do
        explore_object tile, :count => exploration_count
        reward_unit unit, :count => unit_count, :level => unit_level
      end
    end
  end.define(100, [s_quest_with_image[Technology::ZetiumExtraction],
                   s_tech_tree, s_tech_research, s_wp_in_techs]) do
    have_upgraded_to Technology::ZetiumExtraction

    reward_cost Building::ZetiumExtractor, :count => 0.9
  end.define(110, [s_quest_with_image[Building::ZetiumExtractor], s_zetium_tile,
                  s_npc_zex]) do
    have_upgraded_to Building::ZetiumExtractor

    reward_cost Technology::HealingCenter, :count => 0.85
    reward_cost Building::HealingCenter, :count => 0.85
  end.tap do |quest|
    # Resources & VIP mode side quests.
    quest.define(10450) do
      have_upgraded_to Building::MetalExtractor,  :count => 4, :level => 5
      have_upgraded_to Building::CollectorT1,     :count => 5, :level => 5
      have_upgraded_to Building::ZetiumExtractor, :count => 2, :level => 2

      reward_creds (CONFIG['creds.vip'][0][0] * 1.5).ceil
    end.define(10460) do
      become_vip

      reward_creds CONFIG['creds.upgradable.speed_up'][-1][1]
    end.define(10470) do
      accelerate Building

      reward_cost Unit::Shocker, :count => 3, :level => 5
    end
  end.define(120, [s_quest_with_image[Technology::HealingCenter]]) do
    # Build healing center.
    have_upgraded_to Technology::HealingCenter
    have_upgraded_to Building::HealingCenter

    reward_cost Building::MetalStorage, :level => 1, :count => 0.85
    reward_cost Building::MetalStorage, :level => 2, :count => 0.85
    reward_cost Building::EnergyStorage, :level => 1, :count => 0.85
    reward_cost Building::ZetiumStorage, :level => 1, :count => 0.85
  end.define(130, [s_quest, s_resources, s_resource_bar]) do
    # Upgrade your storage buildings.
    have_upgraded_to Building::MetalStorage, :level => 2
    have_upgraded_to Building::EnergyStorage, :level => 1
    have_upgraded_to Building::ZetiumStorage, :level => 1

    reward_cost Building::MetalExtractor, :level => 5, :count => 4
    reward_cost Building::CollectorT1, :level => 5, :count => 6
    reward_cost Building::ZetiumExtractor, :level => 3, :count => 1
    # For speeding up some of the upgrades.
    reward_creds 500
  end.define(140, [s_quest]) do
    # Boost your economy.
    have_upgraded_to Building::MetalExtractor, :level => 5,
                     :count => mex_1st_planet
    have_upgraded_to Building::CollectorT1, :level => 5,
                     :count => energy_1st_planet
    have_upgraded_to Building::ZetiumExtractor, :level => 3,
                     :count => zex_1st_planet

    reward_cost Technology::Market, :count => 0.8
    reward_cost Building::Market, :count => 0.8
  end.define(150, [s_quest_with_image[Technology::Market], s_market]) do
    # Build market.
    have_upgraded_to Technology::Market
    have_upgraded_to Building::Market

    reward_cost Building::Housing, :count => 0.8
  end.define(160, [s_quest_with_image[Building::Housing], s_population]) do
    # Build population building.
    have_upgraded_to Building::Housing

    reward_cost Technology::SpaceFactory, :count => 0.8
  end.define(170, [s_quest_with_image[Technology::SpaceFactory]]) do
    # Research space factory
    have_upgraded_to Technology::SpaceFactory

    reward_cost Building::SpaceFactory, :count => 0.75
  end.define(180, [s_quest_with_image[Building::SpaceFactory],
                  s_construction_tiles]) do
    # Build space factory
    have_upgraded_to Building::SpaceFactory

    reward_cost Unit::Crow, :count => 0.75
  end.define(190, [s_quest_with_image[Unit::Crow]]) do
    # Build a crow.
    have_upgraded_to Unit::Crow

    reward_unit Unit::Crow, :count => 2
  end.define(200, [s_quest_with_image[Unit::Dirac], s_unit_screen_with_space,
                  s_sending_ships, s_combat_in_space]) do
    destroy Unit::Dirac

    reward_unit Unit::Crow, :count => 2
    reward_cost Unit::Crow, :count => 3 * 0.7
  end.define(210, [s_quest, s_move_to_planet, s_claim_planet]) do
    have_planets :count => 2

    reward_unit Unit::Trooper, :count => 5, :level => 6
    reward_unit Unit::Shocker, :count => 2, :level => 8
    reward_unit Unit::Seeker, :count => 2, :level => 8
  end.define(220, [s_quest]) do
    # Boost your economy (again).
    have_upgraded_to Building::MetalExtractor, :level => 6,
                     :count => mex_1st_planet + mex_2nd_planet
    have_upgraded_to Building::CollectorT1, :level => 6,
                     :count => energy_1st_planet + energy_2nd_planet
    have_upgraded_to Building::ZetiumExtractor, :level => 4,
                     :count => zex_1st_planet + zex_2nd_planet

    reward_cost Unit::Mule, :count => 0.7
  end.define(230, [s_quest_with_image[Unit::Mule], s_wreckage, s_load_wreckage,
                  s_unload_resources]) do
    # Resource transportation explained.
    have_upgraded_to Unit::Mule

    reward_unit Unit::Mule
  end.define(240, [s_quest_with_image[Unit::Dirac]]) do
    destroy Unit::Dirac, :count => 8

    reward_unit Unit::Cyrix, :level => 6, :count => 2
  end.define(250, [s_quest_with_image[Unit::Thor]]) do
    destroy Unit::Dirac, :count => 8
    destroy Unit::Thor, :count => 8

    reward_unit Unit::Avenger, :level => 6, :count => 2
  end.define(260, [s_quest_with_image[Unit::Demosis]]) do
    destroy Unit::Dirac, :count => 8
    destroy Unit::Thor, :count => 8
    destroy Unit::Demosis, :count => 3

    reward_creds 2000
  end.define(270, [s_quest_with_image[Technology::Radar], s_radar]) do
    have_upgraded_to Technology::Radar
    have_upgraded_to Building::Radar

    reward_cost Technology::GroundFactory, :count => 0.7
    reward_cost Building::GroundFactory, :count => 0.6
  end.define(280, [s_quest_with_image[Technology::GroundFactory]]) do
    # Build a ground factory
    have_upgraded_to Technology::GroundFactory
    have_upgraded_to Building::GroundFactory

    reward_cost Technology::Mdh, :count => 0.5
  end.define(290, [s_quest_with_image[Technology::Mdh]]) do
    # Research MDH technology
    have_upgraded_to Technology::Mdh

    reward_unit Unit::Trooper, :count => 10, :level => 6
    reward_unit Unit::Shocker, :count => 4, :level => 6
    reward_unit Unit::Seeker, :count => 4, :level => 6
    reward_unit Unit::Scorpion, :count => 2, :level => 6
    reward_unit Unit::Azure, :count => 2, :level => 6
  end.define(300, [s_quest_with_image[Unit::Mdh], s_load_units,
                  s_unload_units, s_deploy_units]) do
    # Have third planet and build Headquarters.
    have_upgraded_to Unit::Mdh
    have_planets :count => 3
    have_upgraded_to Building::Headquarters

    reward_unit Unit::MobileVulcan
    reward_unit Unit::MobileScreamer
    reward_unit Unit::MobileThunder
  end.tap do |quest|
    # Colonization side quest chain.
    quest.define(10500) do
      have_planets :count => 4

      reward_unit Unit::MobileVulcan,   :count => 4
      reward_unit Unit::MobileScreamer, :count => 2
      reward_unit Unit::MobileThunder,  :count => 2
    end.define(10510) do
      have_planets :count => 5

      reward_unit Unit::MobileVulcan,   :count => 6
      reward_unit Unit::MobileScreamer, :count => 4
      reward_unit Unit::MobileThunder,  :count => 4
    end
  end.define(310, [s_quest, s_deploy_units, s_3rd_planet, s_armor_tiles,
                  s_raiders]) do
    # Have fortifications.
    have_upgraded_to Building::MobileVulcan
    have_upgraded_to Building::MobileScreamer
    have_upgraded_to Building::MobileThunder

    reward_unit Unit::Scorpion, :count => 3, :level => 8
    reward_unit Unit::Azure, :count => 3, :level => 8
  end.define(320, [s_quest, s_eco_tier2]) do
    # Evolve economy to tier 2.
    have_upgraded_to Technology::MetalExtractorT2
    have_upgraded_to Technology::CollectorT2
    have_upgraded_to Technology::ZetiumExtractorT2

    have_upgraded_to Building::MetalExtractorT2,
                     :count => mex_1st_planet + mex_2nd_planet + mex_3rd_planet
    have_upgraded_to Building::CollectorT2, :count => energy_3rd_planet
    have_upgraded_to Building::ZetiumExtractorT2,
                     :count => zex_1st_planet + zex_2nd_planet + zex_3rd_planet

    reward_cost Technology::Alliances, :count => 0.5
  end.define(330, [s_quest_with_image[Technology::Alliances], s_join_alliance,
                  s_create_alliance, s_invite_to_alliance]) do
    be_in_alliance

    reward_creds 2000
  end.tap do |quest|
    [
      [10550, Unit::Mule,    15,  5],
      [10555, Unit::Crow,    45, 15],
      [10560, Unit::Cyrix,   30, 10],
      [10565, Unit::Avenger, 45, 15],
      [10570, Unit::Dart,    45, 15],
      [10575, Unit::Rhyno,   15,  3],
    ].each do |id, unit, kill_count, reward_count|
      quest.define(id) do
        destroy     unit, :count => kill_count
        reward_unit unit, :level => 10, :count => reward_count
      end
    end
  end.define(340, [s_quest, s_bg_planets, s_boss_ship, s_pulsars, s_convoys,
                  s_galaxy_battles]) do
    # Explains about arena.
    have_victory_points :count => 500

    reward_creds 2500
  end

  ####################
  ### ACHIEVEMENTS ###
  ####################

  [50, 100, 250, 500, 1000, 2500].each_with_index do |count, index|
    achievement(20000 + index) { explore_any_object :count => count }
  end

  [100, 250, 500, 1000, 2500, 5000, 10000, 25000].each_with_index do
    |count, index|
    achievement(20020 + index) { destroy Unit, :count => count }
  end

  [10, 25, 50, 100, 250, 500].each_with_index do |count, index|
    achievement(20040 + index) { destroy Building, :count => count }
  end

  [5, 10, 25, 50, 75, 100].each_with_index do |count, index|
    achievement(20060 + index) { self_destruct :count => count }
  end

  [5, 10, 25, 50, 75, 100].each_with_index do |count, index|
    achievement(20080 + index) { accelerate_flight :count => count }
  end

  [100, 250, 500, 1000, 2500, 5000, 10000].each_with_index do
    |count, index|
    achievement(20100 + index) { upgrade_to Unit, :count => count }
  end

  [50, 100, 200, 500, 1000].each_with_index do |count, index|
    achievement(20120 + index) { upgrade_to Building, :count => count }
  end

  [5, 10, 15, 20, 25].each_with_index do |count, index|
    achievement(20140 + index) { have_upgraded_to Technology,
      :count => count }
  end

  [5, 15, 25, 50, 100, 150, 200].each_with_index do |count, index|
    achievement(20160 + index) { accelerate Unit, :count => count }
  end

  [5, 15, 25, 50, 100, 150, 200].each_with_index do |count, index|
    achievement(20180 + index) { accelerate Building, :count => count }
  end

  [5, 10, 15, 20, 25].each_with_index do |count, index|
    achievement(20200 + index) { accelerate Technology, :count => count }
  end

  [4, 8, 12, 16, 20].each_with_index do |count, index|
    achievement(20220 + index) { become_vip :count => count, :level => 1 }
  end

  [2, 4, 6, 8, 10].each_with_index do |count, index|
    achievement(20240 + index) { become_vip :count => count, :level => 2 }
  end

  [1, 2, 3, 4, 5].each_with_index do |count, index|
    achievement(20260 + index) { become_vip :count => count, :level => 3 }
  end

  [1, 2, 3, 4, 5].each_with_index do |count, index|
    achievement(20280 + index) { upgrade_to Building::Radar, :count => count }
  end

  [1, 2, 3].each_with_index do |count, index|
    achievement(20290 + index) { upgrade_to Building::Radar,
      :count => count, :level => 2 }
  end

  [25, 50, 100].each_with_index do |count, index|
    achievement(20300 + index) { complete_quests :count => count }
  end

  [25, 50, 100].each_with_index do |count, index|
    achievement(20320 + index) { complete_achievements :count => count }
  end

  [50, 100, 150, 200, 500].each_with_index do |count, index|
    achievement(20340 + index) { battle Combat::OUTCOME_WIN, :count => count }
  end

  [50, 100, 150, 200, 500].each_with_index do |count, index|
    achievement(20360 + index) { battle Combat::OUTCOME_LOSE, :count => count }
  end

  [5, 10, 25, 50, 75, 100].each_with_index do |count, index|
    achievement(20380 + index) { move_building :count => count }
  end

  [
    25000, 50000, 100000, 250000, 500000, 1000000, 2000000
  ].each_with_index do |count, index|
    achievement(20400 + index) { heal_hp count }
  end

  [
    10000, 25000, 50000, 100000, 250000, 500000, 1000000
  ].each_with_index do |count, index|
    achievement(20420 + index) { repair_hp count }
  end
end