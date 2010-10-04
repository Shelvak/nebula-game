Factory.define :planet, :class => Planet::Regular do |m|
  m.solar_system do |r|
    galaxy = r.player \
      ? r.player.galaxy \
      : Factory.create(:galaxy)
    Factory.create :ss_expansion, :galaxy => galaxy,
      :x => (galaxy.solar_systems.maximum(:x) || 0) + 1,
      :y => (galaxy.solar_systems.maximum(:y) || 0) + 1
  end
  m.galaxy { |r| r.solar_system.galaxy }
  m.position 0
  m.variation 0
  m.create_empty true
  m.width 50
  m.height 50
  m.name do |r|
    Planet.generate_planet_name(r.galaxy_id, r.solar_system_id,
      "#{rand(100)}x#{rand(100)}")
  end
  m.size { |r| CONFIG.hashrand('planet.size') }
end

Factory.define :planet_with_player, :parent => :planet do |m|
  m.association :player
end

Factory.define :p_regular, :class => Planet::Regular, :parent => :planet do |m|
end

Factory.define :p_npc, :class => Planet::Npc, :parent => :planet do |m|
end

Factory.define :p_homeworld, :class => Planet::Homeworld, :parent => :planet do |m|
end

Factory.define :p_resource, :class => Planet::Resource, :parent => :planet do |m|
end
Factory.define :p_mining, :parent => :planet,
:class => Planet::Mining do |m|; end

Factory.define :p_jumpgate, :parent => :planet,
:class => Planet::Jumpgate do |m|; end
