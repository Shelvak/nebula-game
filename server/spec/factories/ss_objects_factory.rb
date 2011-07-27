class SsObject::Test < SsObject; end

Factory.define :ss_object, :class => SsObject::Test do |m|
  m.association :solar_system
  m.size { |r| CONFIG.hashrand('ss_object.size') }
end

Factory.define :planet, :class => SsObject::Planet,
:parent => :ss_object do |m|
  m.solar_system do |r|
    galaxy = r.player \
      ? r.player.galaxy \
      : Factory.create(:galaxy)
    Factory.create :solar_system, :galaxy => galaxy,
      :x => (galaxy.solar_systems.maximum(:x) || 0) + 1,
      :y => (galaxy.solar_systems.maximum(:y) || 0) + 1
  end
  m.width 50
  m.height 50
  m.size 80
  m.name do |r|
    "P-#{rand(100000)}"
  end

  # Order is important here, storage must be increased first.
  m.metal_storage 100000
  m.metal 9000

  m.energy_storage 100000
  m.energy 9000

  m.zetium_storage 100000
  m.zetium 9000

  m.last_resources_update { Time.now }
end

Factory.define :planet_with_player, :parent => :planet do |m|
  m.association :player
end

Factory.define :sso_jumpgate, :parent => :ss_object,
:class => SsObject::Jumpgate do |m|; end

Factory.define :sso_asteroid, :parent => :ss_object,
:class => SsObject::Asteroid do |m|
  m.metal_generation_rate { 
    CONFIG.rangerand('ss_object.asteroid.metal_rate') }
  m.energy_generation_rate { 
    CONFIG.rangerand('ss_object.asteroid.energy_rate') }
  m.zetium_generation_rate { 
    CONFIG.rangerand('ss_object.asteroid.zetium_rate') }
end
