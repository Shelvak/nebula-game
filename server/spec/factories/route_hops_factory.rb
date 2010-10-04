Factory.define :route_hop do |m|
  m.association :route
  m.location { GalaxyPoint.new(Factory.create(:galaxy).id, 0, 0) }
  m.arrives_at { 10.minutes.since }
  m.index 0
end