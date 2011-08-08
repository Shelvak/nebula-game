class GalaxyPoint < LocationPoint
  def initialize(id, x, y)
    raise ArgumentError.new(
      "x must be Fixnum, but was #{x.inspect}!"
    ) unless x.is_a?(Fixnum)
    raise ArgumentError.new(
      "y must be Fixnum, but was #{y.inspect}!"
    ) unless y.is_a?(Fixnum)

    super(id, Location::GALAXY, x, y)
  end

  # Player ids that observe given galaxy point.
  def observer_player_ids
    Unit.player_ids_in_location(self) |
      FowGalaxyEntry.observer_player_ids(@id, @x, @y)
  end

  def galaxy_id; @id; end
  def galaxy; Galaxy.find(@id); end
  # Returns nil because galaxy point is not in a solar system.
  def solar_system; nil; end
  # Returns nil because galaxy point is not in a solar system.
  def solar_system_id; nil; end
  def zone; Galaxy.find(@id); end

  def to_s
    "<GP(#{@id}):#{@x},#{@y}>"
  end

  # See Location#client_location
  def client_location
    ClientLocation.new(@id, Location::GALAXY, @x, @y, nil, nil, nil, nil, 
      nil)
  end
end