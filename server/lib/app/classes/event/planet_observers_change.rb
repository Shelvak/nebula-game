class Event::PlanetObserversChange
  # ID for changed planet.
  attr_reader :planet_id

  # Player IDs which cannot observe given planet anymore.
  attr_reader :non_observer_ids

  def initialize(planet_id, non_observer_ids)
    @planet_id = planet_id
    @non_observer_ids = non_observer_ids
  end

  def to_s
    "<Event::PlanetObserversChange planet_id=#{@planet_id.inspect
      } non_observer_ids=#{@non_observer_ids.inspect}>"
  end

  def eql?(other)
    case other
    when self.class
      other.planet_id == @planet_id &&
        other.non_observer_ids == @non_observer_ids
    else
      false
    end
  end

  def ==(other)
    eql?(other)
  end
end