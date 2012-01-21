class Technology::TestTechnology < Technology; end
class Technology::TestLarger < Technology; end
class Technology::TestT2 < Technology; end
class Technology::TestT3 < Technology; end
class Technology::TestT4 < Technology; end
class Technology::TestResourceMod < Technology; end

Factory.define :technology, :class => Technology::TestTechnology do |m|
  m.level 0
  m.scientists do |r|
    r.instance_variable_get("@instance").scientists_min(r.level + 1)
  end
  m.association :player
  m.pause_remainder nil
  m.pause_scientists nil
  m.upgrade_ends_at nil
end

Factory.define :technology_t2,
:class => Technology::TestT2, :parent => :technology do |m|; end

Factory.define :technology_t3,
:class => Technology::TestT3, :parent => :technology do |m|; end

Factory.define :technology_t4,
:class => Technology::TestT4, :parent => :technology do |m|; end

Factory.define :technology_larger,
:class => Technology::TestLarger, :parent => :technology do |m|
  m.scientists 800
end

Factory.define :t_trait_mock, :parent => :technology do |m|
  m.level 1
end

Factory.define :technology_paused, :parent => :technology do |m|
  opts_paused.factory m
  m.scientists nil
  m.pause_scientists 50
end

Factory.define :technology_upgrading, :parent => :technology do |m|
  opts_upgrading.factory m
end

Factory.define :technology_just_upgraded, :parent => :technology do |m|
  opts_just_upgraded.factory m
end

Factory.define :technology_upgrading_larger,
:class => Technology::TestLarger,
:parent => :technology_upgrading do |m|; end

Factory.define :technology_upgrading_t2, :class => Technology::TestT2,
:parent => :technology_upgrading do |m|; end

Factory.define :technology_upgrading_t3, :class => Technology::TestT3,
:parent => :technology_upgrading do |m|; end

Factory.define :technology_upgrading_t4, :class => Technology::TestT4,
:parent => :technology_upgrading do |m|; end

Factory.define :t_zetium_extraction, :parent => :technology,
:class => Technology::ZetiumExtraction do |m|; end

Factory.define :t_collector_t2, :parent => :technology,
:class => Technology::CollectorT2 do |m|; end

Factory.define :t_collector_t3, :parent => :technology,
:class => Technology::CollectorT3 do |m|; end

Factory.define :t_shocker, :parent => :technology,
:class => Technology::Shocker do |m|; end

Factory.define :t_seeker, :parent => :technology,
:class => Technology::Seeker do |m|; end

Factory.define :t_space_factory, :parent => :technology,
:class => Technology::SpaceFactory do |m|; end

Factory.define :t_spy, :parent => :technology,
:class => Technology::Spy do |m|; end

Factory.define :t_saboteur, :parent => :technology,
:class => Technology::Saboteur do |m|; end

Factory.define :t_tactical_reconnaissance, :parent => :technology,
:class => Technology::TacticalReconnaissance do |m|; end

Factory.define :t_sattelite_hacking, :parent => :technology,
:class => Technology::SatteliteHacking do |m|; end

Factory.define :t_camouflage_suits, :parent => :technology,
:class => Technology::CamouflageSuits do |m|; end

Factory.define :t_r14_charges, :parent => :technology,
:class => Technology::R14Charges do |m|; end

Factory.define :t_spaceport, :parent => :technology,
:class => Technology::Spaceport do |m|; end

Factory.define :t_metabolic_chargers, :parent => :technology,
:class => Technology::MetabolicChargers do |m|; end

Factory.define :t_high_velocity_charges, :parent => :technology,
:class => Technology::HighVelocityCharges do |m|; end

Factory.define :t_radar, :parent => :technology,
:class => Technology::Radar do |m|; end

Factory.define :t_resource_transporter, :parent => :technology,
:class => Technology::ResourceTransporter do |m|; end

Factory.define :t_fiery_melters, :parent => :technology,
:class => Technology::FieryMelters do |m|; end

Factory.define :t_superconductor_technology, :parent => :technology,
:class => Technology::SuperconductorTechnology do |m|; end

Factory.define :t_powdered_zetium, :parent => :technology,
:class => Technology::PowderedZetium do |m|; end

Factory.define :t_vulcan, :parent => :technology,
:class => Technology::Vulcan do |m|; end

Factory.define :t_screamer, :parent => :technology,
:class => Technology::Screamer do |m|; end

Factory.define :t_thunder, :parent => :technology,
:class => Technology::Thunder do |m|; end

Factory.define :t_dart, :parent => :technology,
:class => Technology::Dart do |m|; end

Factory.define :t_cyrix, :parent => :technology,
:class => Technology::Cyrix do |m|; end

Factory.define :t_avenger, :parent => :technology,
:class => Technology::Avenger do |m|; end

Factory.define :t_rhyno, :parent => :technology,
:class => Technology::Rhyno do |m|; end

Factory.define :t_ground_factory, :parent => :technology,
:class => Technology::GroundFactory do |m|; end

Factory.define :t_azure, :parent => :technology,
:class => Technology::Azure do |m|; end

Factory.define :t_mdh, :parent => :technology,
:class => Technology::Mdh do |m|; end

Factory.define :t_metal_extractor_t2, :parent => :technology,
:class => Technology::MetalExtractorT2 do |m|; end

Factory.define :t_zetium_extractor_t2, :parent => :technology,
:class => Technology::ZetiumExtractorT2 do |m|; end

Factory.define :t_trooper, :parent => :technology,
:class => Technology::Trooper do |m|; end

Factory.define :t_ships_armor, :parent => :technology,
:class => Technology::ShipsArmor do |m|; end

Factory.define :t_ships_damage, :parent => :technology,
:class => Technology::ShipsDamage do |m|; end

Factory.define :t_tanks_damage, :parent => :technology,
:class => Technology::TanksDamage do |m|; end

Factory.define :t_tanks_armor, :parent => :technology,
:class => Technology::TanksArmor do |m|; end

Factory.define :t_scorpion, :parent => :technology,
:class => Technology::Scorpion do |m|; end

Factory.define :t_crow, :parent => :technology,
:class => Technology::Crow do |m|; end

Factory.define :t_crane, :parent => :technology,
:class => Technology::Crane do |m|; end

Factory.define :t_healing_center, :parent => :technology,
:class => Technology::HealingCenter do |m|; end

Factory.define :t_jumper, :parent => :technology,
:class => Technology::Jumper do |m|; end

Factory.define :t_alliances, :parent => :technology,
:class => Technology::Alliances do |m|; end

Factory.define :t_heavy_flight, :parent => :technology,
:class => Technology::HeavyFlight do |m|; end

Factory.define :t_defensive_portal, :parent => :technology,
:class => Technology::DefensivePortal do |m|; end

Factory.define :t_zeus, :parent => :technology,
:class => Technology::Zeus do |m|; end

Factory.define :t_market, :parent => :technology,
:class => Technology::Market do |m|; end

Factory.define :t_mobile_vulcan, :parent => :technology,
:class => Technology::MobileVulcan do |m|; end

Factory.define :t_mobile_screamer, :parent => :technology,
:class => Technology::MobileScreamer do |m|; end

Factory.define :t_mobile_thunder, :parent => :technology,
:class => Technology::MobileThunder do |m|; end

Factory.define :t_metal_storage, :parent => :technology,
:class => Technology::MetalStorage do |m|; end

Factory.define :t_energy_storage, :parent => :technology,
:class => Technology::EnergyStorage do |m|; end

Factory.define :t_zetium_storage, :parent => :technology,
:class => Technology::ZetiumStorage do |m|; end

Factory.define :t_ship_storage, :parent => :technology,
:class => Technology::ShipStorage do |m|; end

Factory.define :t_building_repair, :parent => :technology,
:class => Technology::BuildingRepair do |m|; end

Factory.define :t_turret_armor, :parent => :technology,
:class => Technology::TurretArmor do |m|; end

Factory.define :t_turret_damage, :parent => :technology,
:class => Technology::TurretDamage do |m|; end

Factory.define :t_trooper_damage, :parent => :technology,
:class => Technology::TrooperDamage do |m|; end

Factory.define :t_shocker_damage, :parent => :technology,
:class => Technology::ShockerDamage do |m|; end

Factory.define :t_seeker_damage, :parent => :technology,
:class => Technology::SeekerDamage do |m|; end

Factory.define :t_scorpion_damage, :parent => :technology,
:class => Technology::ScorpionDamage do |m|; end

Factory.define :t_azure_damage, :parent => :technology,
:class => Technology::AzureDamage do |m|; end

Factory.define :t_mantis_damage, :parent => :technology,
:class => Technology::MantisDamage do |m|; end

Factory.define :t_zeus_damage, :parent => :technology,
:class => Technology::ZeusDamage do |m|; end

Factory.define :t_gnat_damage, :parent => :technology,
:class => Technology::GnatDamage do |m|; end

Factory.define :t_glancer_damage, :parent => :technology,
:class => Technology::GlancerDamage do |m|; end

Factory.define :t_spudder_damage, :parent => :technology,
:class => Technology::SpudderDamage do |m|; end

Factory.define :t_gnawer_damage, :parent => :technology,
:class => Technology::GnawerDamage do |m|; end

Factory.define :t_ground_damage, :parent => :technology,
:class => Technology::GroundDamage do |m|; end

Factory.define :t_space_damage, :parent => :technology,
:class => Technology::SpaceDamage do |m|; end

Factory.define :t_npc_ground_damage, :parent => :technology,
:class => Technology::NpcGroundDamage do |m|; end

Factory.define :t_npc_space_damage, :parent => :technology,
:class => Technology::NpcSpaceDamage do |m|; end

Factory.define :t_trooper_armor, :parent => :technology,
:class => Technology::TrooperArmor do |m|; end

Factory.define :t_shocker_armor, :parent => :technology,
:class => Technology::ShockerArmor do |m|; end

Factory.define :t_seeker_armor, :parent => :technology,
:class => Technology::SeekerArmor do |m|; end

Factory.define :t_scorpion_armor, :parent => :technology,
:class => Technology::ScorpionArmor do |m|; end

Factory.define :t_azure_armor, :parent => :technology,
:class => Technology::AzureArmor do |m|; end

Factory.define :t_mantis_armor, :parent => :technology,
:class => Technology::MantisArmor do |m|; end

Factory.define :t_zeus_armor, :parent => :technology,
:class => Technology::ZeusArmor do |m|; end

Factory.define :t_gnat_armor, :parent => :technology,
:class => Technology::GnatArmor do |m|; end

Factory.define :t_glancer_armor, :parent => :technology,
:class => Technology::GlancerArmor do |m|; end

Factory.define :t_spudder_armor, :parent => :technology,
:class => Technology::SpudderArmor do |m|; end

Factory.define :t_gnawer_armor, :parent => :technology,
:class => Technology::GnawerArmor do |m|; end

Factory.define :t_ground_armor, :parent => :technology,
:class => Technology::GroundArmor do |m|; end

Factory.define :t_space_armor, :parent => :technology,
:class => Technology::SpaceArmor do |m|; end

Factory.define :t_npc_ground_armor, :parent => :technology,
:class => Technology::NpcGroundArmor do |m|; end

Factory.define :t_npc_space_armor, :parent => :technology,
:class => Technology::NpcSpaceArmor do |m|; end

Factory.define :t_trooper_critical, :parent => :technology,
:class => Technology::TrooperCritical do |m|; end

Factory.define :t_shocker_critical, :parent => :technology,
:class => Technology::ShockerCritical do |m|; end

Factory.define :t_seeker_critical, :parent => :technology,
:class => Technology::SeekerCritical do |m|; end

Factory.define :t_scorpion_critical, :parent => :technology,
:class => Technology::ScorpionCritical do |m|; end

Factory.define :t_azure_critical, :parent => :technology,
:class => Technology::AzureCritical do |m|; end

Factory.define :t_mantis_critical, :parent => :technology,
:class => Technology::MantisCritical do |m|; end

Factory.define :t_zeus_critical, :parent => :technology,
:class => Technology::ZeusCritical do |m|; end

Factory.define :t_gnat_critical, :parent => :technology,
:class => Technology::GnatCritical do |m|; end

Factory.define :t_glancer_critical, :parent => :technology,
:class => Technology::GlancerCritical do |m|; end

Factory.define :t_spudder_critical, :parent => :technology,
:class => Technology::SpudderCritical do |m|; end

Factory.define :t_gnawer_critical, :parent => :technology,
:class => Technology::GnawerCritical do |m|; end

Factory.define :t_ground_critical, :parent => :technology,
:class => Technology::GroundCritical do |m|; end

Factory.define :t_space_critical, :parent => :technology,
:class => Technology::SpaceCritical do |m|; end

Factory.define :t_turret_critical, :parent => :technology,
:class => Technology::TurretCritical do |m|; end

Factory.define :t_npc_ground_critical, :parent => :technology,
:class => Technology::NpcGroundCritical do |m|; end

Factory.define :t_npc_space_critical, :parent => :technology,
:class => Technology::NpcSpaceCritical do |m|; end

Factory.define :t_trooper_absorption, :parent => :technology,
:class => Technology::TrooperAbsorption do |m|; end

Factory.define :t_shocker_absorption, :parent => :technology,
:class => Technology::ShockerAbsorption do |m|; end

Factory.define :t_seeker_absorption, :parent => :technology,
:class => Technology::SeekerAbsorption do |m|; end

Factory.define :t_scorpion_absorption, :parent => :technology,
:class => Technology::ScorpionAbsorption do |m|; end

Factory.define :t_azure_absorption, :parent => :technology,
:class => Technology::AzureAbsorption do |m|; end

Factory.define :t_mantis_absorption, :parent => :technology,
:class => Technology::MantisAbsorption do |m|; end

Factory.define :t_zeus_absorption, :parent => :technology,
:class => Technology::ZeusAbsorption do |m|; end

Factory.define :t_gnat_absorption, :parent => :technology,
:class => Technology::GnatAbsorption do |m|; end

Factory.define :t_glancer_absorption, :parent => :technology,
:class => Technology::GlancerAbsorption do |m|; end

Factory.define :t_spudder_absorption, :parent => :technology,
:class => Technology::SpudderAbsorption do |m|; end

Factory.define :t_gnawer_absorption, :parent => :technology,
:class => Technology::GnawerAbsorption do |m|; end

Factory.define :t_ground_absorption, :parent => :technology,
:class => Technology::GroundAbsorption do |m|; end

Factory.define :t_space_absorption, :parent => :technology,
:class => Technology::SpaceAbsorption do |m|; end

Factory.define :t_turret_absorption, :parent => :technology,
:class => Technology::TurretAbsorption do |m|; end

Factory.define :t_npc_ground_absorption, :parent => :technology,
:class => Technology::NpcGroundAbsorption do |m|; end

Factory.define :t_npc_space_absorption, :parent => :technology,
:class => Technology::NpcSpaceAbsorption do |m|; end

Factory.define :t_crow_damage, :parent => :technology,
:class => Technology::CrowDamage do |m|; end

Factory.define :t_cyrix_damage, :parent => :technology,
:class => Technology::CyrixDamage do |m|; end

Factory.define :t_avenger_damage, :parent => :technology,
:class => Technology::AvengerDamage do |m|; end

Factory.define :t_dart_damage, :parent => :technology,
:class => Technology::DartDamage do |m|; end

Factory.define :t_rhyno_damage, :parent => :technology,
:class => Technology::RhynoDamage do |m|; end

Factory.define :t_dirac_damage, :parent => :technology,
:class => Technology::DiracDamage do |m|; end

Factory.define :t_thor_damage, :parent => :technology,
:class => Technology::ThorDamage do |m|; end

Factory.define :t_demosis_damage, :parent => :technology,
:class => Technology::DemosisDamage do |m|; end

Factory.define :t_crow_armor, :parent => :technology,
:class => Technology::CrowArmor do |m|; end

Factory.define :t_cyrix_armor, :parent => :technology,
:class => Technology::CyrixArmor do |m|; end

Factory.define :t_avenger_armor, :parent => :technology,
:class => Technology::AvengerArmor do |m|; end

Factory.define :t_dart_armor, :parent => :technology,
:class => Technology::DartArmor do |m|; end

Factory.define :t_rhyno_armor, :parent => :technology,
:class => Technology::RhynoArmor do |m|; end

Factory.define :t_dirac_armor, :parent => :technology,
:class => Technology::DiracArmor do |m|; end

Factory.define :t_thor_armor, :parent => :technology,
:class => Technology::ThorArmor do |m|; end

Factory.define :t_demosis_armor, :parent => :technology,
:class => Technology::DemosisArmor do |m|; end

Factory.define :t_crow_critical, :parent => :technology,
:class => Technology::CrowCritical do |m|; end

Factory.define :t_cyrix_critical, :parent => :technology,
:class => Technology::CyrixCritical do |m|; end

Factory.define :t_avenger_critical, :parent => :technology,
:class => Technology::AvengerCritical do |m|; end

Factory.define :t_dart_critical, :parent => :technology,
:class => Technology::DartCritical do |m|; end

Factory.define :t_rhyno_critical, :parent => :technology,
:class => Technology::RhynoCritical do |m|; end

Factory.define :t_dirac_critical, :parent => :technology,
:class => Technology::DiracCritical do |m|; end

Factory.define :t_thor_critical, :parent => :technology,
:class => Technology::ThorCritical do |m|; end

Factory.define :t_demosis_critical, :parent => :technology,
:class => Technology::DemosisCritical do |m|; end

Factory.define :t_crow_absorption, :parent => :technology,
:class => Technology::CrowAbsorption do |m|; end

Factory.define :t_cyrix_absorption, :parent => :technology,
:class => Technology::CyrixAbsorption do |m|; end

Factory.define :t_avenger_absorption, :parent => :technology,
:class => Technology::AvengerAbsorption do |m|; end

Factory.define :t_dart_absorption, :parent => :technology,
:class => Technology::DartAbsorption do |m|; end

Factory.define :t_rhyno_absorption, :parent => :technology,
:class => Technology::RhynoAbsorption do |m|; end

Factory.define :t_dirac_absorption, :parent => :technology,
:class => Technology::DiracAbsorption do |m|; end

Factory.define :t_thor_absorption, :parent => :technology,
:class => Technology::ThorAbsorption do |m|; end

Factory.define :t_demosis_absorption, :parent => :technology,
:class => Technology::DemosisAbsorption do |m|; end

Factory.define :t_crow_speed, :parent => :technology,
:class => Technology::CrowSpeed do |m|; end

Factory.define :t_cyrix_speed, :parent => :technology,
:class => Technology::CyrixSpeed do |m|; end

Factory.define :t_avenger_speed, :parent => :technology,
:class => Technology::AvengerSpeed do |m|; end

Factory.define :t_dart_speed, :parent => :technology,
:class => Technology::DartSpeed do |m|; end

Factory.define :t_rhyno_speed, :parent => :technology,
:class => Technology::RhynoSpeed do |m|; end

Factory.define :t_dirac_speed, :parent => :technology,
:class => Technology::DiracSpeed do |m|; end

Factory.define :t_thor_speed, :parent => :technology,
:class => Technology::ThorSpeed do |m|; end

Factory.define :t_demosis_speed, :parent => :technology,
:class => Technology::DemosisSpeed do |m|; end
