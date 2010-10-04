Factory.define :construction_queue_entry do |m|
  m.association :constructor, :factory => :b_constructor_test
  m.constructable_type "Building::TestBuilding"
  m.position 0
  m.count 1
end