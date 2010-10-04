Factory.define :cooldown do |m|
  m.location_id { Factory.create(:galaxy).id }
  m.location_type Location::GALAXY
  m.location_x 10
  m.location_y -4
end