Factory.define :cooldown do |m|
  m.location { GalaxyPoint.new(Factory.create(:galaxy).id, 10, -4) }
  m.ends_at 10.minutes.from_now
end