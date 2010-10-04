class MainEventHandler
  def initialize
    EventBroker.register(self)
  end

  def fire(object, event, reason)
    case event
    when EventBroker::MOVEMENT
      handle_movement(object, reason)
    end
  end

  def handle_movement(movement_event, reason)
    if reason == EventBroker::REASON_BETWEEN_ZONES
      # Increase/decrease FOW solar system cache counters upon units
      # changing zones.

      route = movement_event.route
      unit_count = route.cached_units.values.sum
      previous_location = movement_event.previous_location
      current_location = route.current

      if previous_location.type == Location::SOLAR_SYSTEM &&
          current_location.type == Location::SOLAR_SYSTEM
        raise ArgumentError.new(
          "Cannot hop from SS to SS directly, must be a bug in the code! #{
            movement_event.inspect}"
        )
      elsif previous_location.type == Location::SOLAR_SYSTEM
        FowSsEntry.decrease(previous_location.id, route.player, unit_count)
      elsif current_location.type == Location::SOLAR_SYSTEM
        FowSsEntry.increase(current_location.id, route.player, unit_count)
      end
    end
  end
end