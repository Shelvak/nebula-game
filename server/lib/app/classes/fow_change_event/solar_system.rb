# FOW change event when single solar system is changed.
class FowChangeEvent::SolarSystem < FowChangeEvent
  attr_reader :solar_system_id

  def initialize(player, alliance, solar_system_id)
    @solar_system_id = solar_system_id
    super(player, alliance)
  end

  def solar_system
    SolarSystem.find(@solar_system_id)
  end

  def ==(other)
    other.is_a?(self.class) && super(other) &&
      @solar_system_id == other.solar_system_id
  end
end