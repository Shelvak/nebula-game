Factory.define :solar_system, :class => SolarSystem::Expansion do |m|
  m.association :galaxy
  m.x { (SolarSystem.maximum(:x) || 0) + 1 }
  m.y { (SolarSystem.maximum(:y) || 0) + 1 }
  m.create_empty true
end

Factory.define :ss_homeworld, :class => SolarSystem::Homeworld,
:parent => :solar_system do |m|
end

Factory.define :ss_expansion, :class => SolarSystem::Expansion,
:parent => :solar_system do |m|
end

Factory.define :ss_resource, :class => SolarSystem::Resource,
:parent => :solar_system do |m|
end