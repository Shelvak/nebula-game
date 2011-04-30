class PlanetPoint < LocationPoint
  def initialize(id)
    super(id, Location::SS_OBJECT, nil, nil)
  end

  def to_s
    "<PP(#{@id})>"
  end
end
