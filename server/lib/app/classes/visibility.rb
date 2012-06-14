module Visibility
  # TODO: doc
  def self.track_location_changes(location_point, &block)
    typesig binding, LocationPoint

    return yield unless location_point.type == Location::SOLAR_SYSTEM ||
      location_point.type == Location::SS_OBJECT

    solar_system_id = ss_previous_player_ids = previous_metadatas = ret_val =
      nil

    yielder = lambda do
      ss_previous_player_ids = SolarSystem.observer_player_ids(solar_system_id)
      previous_metadatas = SolarSystem::Metadatas.new(solar_system_id)
      ret_val = block.call
    end

    case location_point.type
    when Location::SOLAR_SYSTEM
      solar_system_id = location_point.id
      yielder.call
    when Location::SS_OBJECT
      planet = location_point.object
      raise "Visibility changes in #{planet.inspect} does not make any sense!" \
        unless planet.is_a?(SsObject::Planet)

      solar_system_id = planet.solar_system_id
      planet_old_observers = planet.observer_player_ids
      yielder.call
      planet_new_observers = planet.observer_player_ids

      if planet_old_observers != planet_new_observers
        # If observers changed, dispatch changed on the planet.
        EventBroker.fire(planet, EventBroker::CHANGED)
        # And if some players were viewing the planet, but they can't
        # anymore, dispatch event to unset their session planet ids.
        EventBroker.fire(
          Event::PlanetObserversChange.
            new(planet.id, planet_old_observers - planet_new_observers),
          EventBroker::CREATED
        )
      end
    end
    ss_current_player_ids = SolarSystem.observer_player_ids(solar_system_id)
    current_metadatas = SolarSystem::Metadatas.new(solar_system_id)

    created = ss_current_player_ids - ss_previous_player_ids
    destroyed = ss_previous_player_ids - ss_current_player_ids
    updated = ss_current_player_ids & ss_previous_player_ids

    unless created.blank?
      players = Player.find(created)
      row = SolarSystem.select("x, y, kind, player_id").
        where(id: solar_system_id).c_select_one
      x, y, kind, player_minimal = row["x"], row["y"], row["kind"],
        Player.minimal(row["player_id"])

      EventBroker.fire(
        Event::FowChange::SsCreated.new(
          solar_system_id, x, y, kind, players, current_metadatas
        ),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end

    unless destroyed.blank?
      EventBroker.fire(
        Event::FowChange::SsDestroyed.new(solar_system_id, destroyed),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end

    unless updated.blank?
      players = Player.find(updated).reject do |player|
        friendly_ids = player.friendly_ids
        alliance_ids = player.alliance_ids

        previous = previous_metadatas.for_existing(
          solar_system_id, player.id, friendly_ids, alliance_ids
        )
        current = current_metadatas.for_existing(
          solar_system_id, player.id, friendly_ids, alliance_ids
        )

        previous == current
      end

      EventBroker.fire(
        Event::FowChange::SsUpdated.new(
          solar_system_id, players, current_metadatas
        ),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end

    ret_val
  end

  # TODO: doc
  def self.track_movement_changes(source_location_point, target_location_point)
    typesig binding, LocationPoint, LocationPoint

    if source_location_point.type == Location::SS_OBJECT
      track_location_changes(source_location_point)
    elsif target_location_point.type == Location::SS_OBJECT
      track_location_changes(target_location_point)
    elsif source_location_point.type == Location::SOLAR_SYSTEM
      track_location_changes(source_location_point)
    elsif target_location_point.type == Location::SOLAR_SYSTEM
      track_location_changes(target_location_point)
    end
  end


  # Checks if any of the given _locations_ is a planet. If so it
  # calculates observer ids before and after block execution. If they are
  # changed - dispatches changed event for that planet.
  def changing_viewable(locations)
    # Check if any of these locations are planets.
    locations.each do |location|
      if location.type == Location::SS_OBJECT

      end
    end

    # If none of the locations were planets, just yield the block.
    yield
  end

  def tracking_changes(solar_system_id, update_metadata=false)
    typesig binding, Fixnum

    previous_player_ids = observer_player_ids(solar_system_id)
    ret_val = yield
    current_player_ids = observer_player_ids(solar_system_id)

    # Some changes occurred.
    if previous_player_ids != current_player_ids
      created = current_player_ids - previous_player_ids
      destroyed = previous_player_ids - current_player_ids


    end

    ret_val
  end
end