Factory.define :route do |m|
  m.association :player
  m.source do |r|
    GalaxyPoint.new(r.player.galaxy_id, -5, -4).client_location
  end
  m.current do |r|
    GalaxyPoint.new(r.player.galaxy_id, -3, -2).client_location
  end
  m.target do |r|
    GalaxyPoint.new(r.player.galaxy_id, 0, 0).client_location
  end
  m.first_hop { 1.minute.since }
  m.arrives_at { 10.minutes.since }
  m.cached_units "Mule" => 10
end