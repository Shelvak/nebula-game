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
end