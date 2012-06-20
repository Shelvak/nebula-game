Factory.define :fge, class: FowGalaxyEntry do |m|
  m.association :galaxy
  m.rectangle Rectangle.new(0, 0, 4, 4)
  m.association :player
  m.counter 1
end