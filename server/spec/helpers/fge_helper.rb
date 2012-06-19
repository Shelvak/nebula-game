def fge_around(solar_system, options={})
  options.merge!(galaxy: solar_system.galaxy, rectangle: Rectangle.new(
    solar_system.x, solar_system.y, solar_system.x + 1, solar_system.y + 1
  ))
  Factory.create(:fge, options)
end