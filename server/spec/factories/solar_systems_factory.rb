Factory.define :solar_system do |m|
  m.association :galaxy
  m.x { (SolarSystem.maximum(:x) || 0) + 1 }
  m.y { (SolarSystem.maximum(:y) || 0) + 1 }
end

Factory.define :battleground, :parent => :solar_system do |m|
  m.x nil
  m.y nil
end

Factory.define :wormhole, :parent => :solar_system do |m|
  m.wormhole true
end