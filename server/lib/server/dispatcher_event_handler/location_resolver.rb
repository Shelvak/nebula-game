class DispatcherEventHandler::LocationResolver
  class << self
    # Resolves player ids that should be notified about events in _location_.
    # Also returns filter for that location.
    def resolve(location)
      case location.type
      when Location::GALAXY
        [
          FowGalaxyEntry.
            observer_player_ids(location.id, location.x, location.y),
          nil
        ]
      when Location::SOLAR_SYSTEM
        [
          FowSsEntry.observer_player_ids(location.id),
          Dispatcher::PushFilter.solar_system(location.id)
        ]
      when Location::SS_OBJECT
        [
          location.object.observer_player_ids,
          Dispatcher::PushFilter.ss_object(location.id)
        ]
      when Location::UNIT
        unit = location.object
        parent = unit.location.object
        raise(
          "Support for dispatching when parent is #{parent
          } is not supported for units"
        ) unless parent.is_a?(SsObject::Planet)
        [
          parent.observer_player_ids,
          Dispatcher::PushFilter.ss_object(parent.id)
        ]
      when Location::BUILDING
        building = location.object
        [
          building.observer_player_ids,
          Dispatcher::PushFilter.ss_object(building.planet_id)
        ]
      else
        raise ArgumentError.new("Unknown location type #{location.type}!")
      end
    end

    # Resolves player ids that should be notified about movement in _location_.
    # Also returns filter for that location.
    #
    # This one extends #resolve_location. If location is a galaxy point, friendly
    # players should be notified even if they have no radars enabled.
    #
    def resolve_movement(location, friendly_ids)
      player_ids, filter = resolve(location)
      player_ids |= friendly_ids if location.type == Location::GALAXY
      [player_ids, filter]
    end
  end
end