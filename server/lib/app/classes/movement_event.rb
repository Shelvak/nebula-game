class MovementEvent
  attr_reader :route, :previous_location, :current_hop, :next_hop

  def initialize(route, previous_location, current_hop, next_hop)
    @route = route
    @previous_location = previous_location
    @current_hop = current_hop
    @next_hop = next_hop
  end

  def ==(other)
    if other.is_a?(self.class)
      route == other.route &&
        previous_location == other.previous_location &&
        current_hop == other.current_hop && next_hop == other.next_hop
    else
      false
    end
  end
end