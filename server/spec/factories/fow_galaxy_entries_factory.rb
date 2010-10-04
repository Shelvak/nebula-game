Factory.define :fow_galaxy_entry do |m|
  m.association :galaxy
  m.rectangle Rectangle.new(0, 0, 4, 4)
  m.counter 1
end

Factory.define :fge_player, :parent => :fow_galaxy_entry do |m|
  m.association :player
end

Factory.define :fge_alliance, :parent => :fow_galaxy_entry do |m|
  m.association :alliance
end