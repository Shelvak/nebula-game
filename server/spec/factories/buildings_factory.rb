class Building::TestBuilding < Building; end

Factory.define :building, :class => Building::TestBuilding do |m|
  m.association :planet, :factory => :planet_with_player
  m.x 0
  m.y 0
end

Factory.define :building_in_construction, :parent => :building do |m|
  opts_upgrading.factory m
end

Factory.define :building_just_constructed,
:parent => :building_in_construction do |m|
  opts_just_upgraded.factory m
end

Factory.define :building_just_started,
:parent => :building_in_construction do |m|
  opts_just_started.factory m
end

Factory.define :building_built, :class => Building::TestBuilding,
:parent => :building do |m|
  opts_built.factory m
end

[
  %w{test_energy_user1 1},
  %w{test_energy_user2 2},
  %w{test_energy_user3 3},
  %w{test_energy_user4 4},
].each do |base, usage|
  class_name = "Building::#{base.camelcase}"
  
  eval "class #{class_name} < Building; end"
  Factory.define :"b_#{base}",
      :class => class_name.constantize,
      :parent => :building_built do |m|
    opts_active.factory m
  end
end

Factory.define :b_trait_mock, :class => Building::TestBuilding,
:parent => :building_built do |m|; end

class Building::ConstructorTest < Building; end

Factory.define :b_constructor_test, :parent => :b_trait_mock,
:class => Building::ConstructorTest do |m|
  opts_active.factory m
  m.level 1
end

Factory.define :b_constructor_with_constructable, :parent => :b_trait_mock,
:class => Building::ConstructorTest do |m|
  opts_working.factory m
  m.level 1
  m.constructable do |r|
    Factory.create(:unit, :location => r.planet)
  end
end

class Building::TestUnconstructable < Building; end
Factory.define :b_test_unconstructable, :parent => :b_trait_mock,
:class => Building::TestUnconstructable do |m|
end

Factory.define :b_mothership, :parent => :building_built,
:class => Building::Mothership do |m|
end

Factory.define :b_headquarters, :class => Building::Headquarters,
:parent => :building_built do |m|
end

Factory.define :b_energy_storage, :class => Building::EnergyStorage,
:parent => :building_built do |m|; end

Factory.define :b_metal_extractor, :class => Building::MetalExtractor,
:parent => :building_built do |m|; end

Factory.define :b_metal_storage, :class => Building::MetalStorage,
:parent => :building_built do |m|; end

Factory.define :b_collector_t1, :class => Building::CollectorT1,
:parent => :building_built do |m|; end

Factory.define :b_collector_t2, :class => Building::CollectorT2,
:parent => :building_built do |m|; end

Factory.define :b_collector_t3, :class => Building::CollectorT3,
:parent => :building_built do |m|; end

Factory.define :b_collector_t1_jc, :class => Building::CollectorT1,
:parent => :building_just_constructed do |m|; end

Factory.define :b_research_center, :parent => :building_built,
:class => Building::ResearchCenter do |m|; end

Factory.define :b_barracks, :parent => :building_built,
:class => Building::Barracks do |m|; end

Factory.define :b_npc_metal_extractor, :parent => :building_built,
:class => Building::NpcMetalExtractor do |m|; end

Factory.define :b_npc_zetium_extractor, :parent => :building_built,
:class => Building::NpcZetiumExtractor do |m|; end

Factory.define :b_npc_geothermal_plant, :parent => :building_built,
:class => Building::NpcGeothermalPlant do |m|; end

Factory.define :b_resource_transporter, :parent => :building_built,
:class => Building::ResourceTransporter do |m|; end

Factory.define :b_zetium_extractor, :parent => :building_built,
:class => Building::ZetiumExtractor do |m|; end

Factory.define :b_zetium_storage, :parent => :building_built,
:class => Building::ZetiumStorage do |m|; end

Factory.define :b_radar, :parent => :building_built,
:class => Building::Radar do |m|; end

Factory.define :b_npc_solar_plant, :parent => :building_built,
:class => Building::NpcSolarPlant do |m|; end

Factory.define :b_npc_communications_hub, :parent => :building_built,
:class => Building::NpcCommunicationsHub do |m|; end

Factory.define :b_npc_temple, :parent => :building_built,
:class => Building::NpcTemple do |m|; end

Factory.define :b_npc_excavation_site, :parent => :building_built,
:class => Building::NpcExcavationSite do |m|; end

Factory.define :b_npc_research_center, :parent => :building_built,
:class => Building::NpcResearchCenter do |m|; end

Factory.define :b_npc_jumpgate, :parent => :building_built,
:class => Building::NpcJumpgate do |m|; end

Factory.define :b_vulcan, :parent => :building_built,
:class => Building::Vulcan do |m|; end

Factory.define :b_thunder, :parent => :building_built,
:class => Building::Thunder do |m|; end

Factory.define :b_screamer, :parent => :building_built,
:class => Building::Screamer do |m|; end

Factory.define :b_ground_factory, :parent => :building_built,
:class => Building::GroundFactory do |m|; end

Factory.define :b_space_factory, :parent => :building_built,
:class => Building::SpaceFactory do |m|; end

Factory.define :b_metal_extractor_t2, :parent => :building_built,
:class => Building::MetalExtractorT2 do |m|; end

Factory.define :b_zetium_extractor_t2, :parent => :building_built,
:class => Building::ZetiumExtractorT2 do |m|; end

Factory.define :b_crane, :parent => :building_built,
:class => Building::Crane do |m|; end

Factory.define :b_healing_center, :parent => :building_built,
:class => Building::HealingCenter do |m|; end

Factory.define :b_npc_infantry_factory, :parent => :building_built,
:class => Building::NpcInfantryFactory do |m|; end

Factory.define :b_npc_tank_factory, :parent => :building_built,
:class => Building::NpcTankFactory do |m|; end

Factory.define :b_npc_space_factory, :parent => :building_built,
:class => Building::NpcSpaceFactory do |m|; end

Factory.define :b_npc_hall, :parent => :building_built,
:class => Building::NpcHall do |m|; end
Factory.define :b_housing, :parent => :building_built,
:class => Building::Housing do |m|; end

Factory.define :b_defensive_portal, :parent => :building_built,
:class => Building::DefensivePortal do |m|; end

Factory.define :b_market, :parent => :building_built,
:class => Building::Market do |m|; end

Factory.define :b_mobile_thunder, :parent => :building_built,
:class => Building::MobileThunder do |m|; end

Factory.define :b_mobile_screamer, :parent => :building_built,
:class => Building::MobileScreamer do |m|; end

Factory.define :b_mobile_vulcan, :parent => :building_built,
:class => Building::MobileVulcan do |m|; end
