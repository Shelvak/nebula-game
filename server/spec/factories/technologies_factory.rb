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
