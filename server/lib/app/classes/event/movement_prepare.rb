# Event for movement preparation.
class Event::MovementPrepare
  attr_reader :route, :unit_ids

  def initialize(route, unit_ids)
    @route = route
    @unit_ids = unit_ids
  end
end
