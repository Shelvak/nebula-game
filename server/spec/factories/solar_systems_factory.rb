Factory.define :solar_system do |m|
  m.association :galaxy
  m.x { (SolarSystem.maximum(:x) || 0) + 1 }
  m.y { (SolarSystem.maximum(:y) || 0) + 1 }
end