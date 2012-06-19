module Visibility
  class << self
    # Tracks location visibility changes in a block and dispatches appropriate
    # events.
    def track_location_changes(location_point, &block)
      typesig binding, LocationPoint, Proc

      return block.call unless location_point.type == Location::SOLAR_SYSTEM ||
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
        planet = without_locking { location_point.object.freeze }
        raise "Visibility changes in #{planet} does not make any sense!" \
          unless planet.is_a?(SsObject::Planet)

        solar_system_id = planet.solar_system_id
        planet_old_observers = planet.observer_player_ids
        yielder.call
        planet_new_observers = planet.observer_player_ids

        dispatch_planet_changes(
          planet, planet_old_observers, planet_new_observers
        ) unless planet_old_observers == planet_new_observers
      end
      ss_current_player_ids = SolarSystem.observer_player_ids(solar_system_id)
      current_metadatas = SolarSystem::Metadatas.new(solar_system_id)

      ss_created = ss_current_player_ids - ss_previous_player_ids
      ss_updated = ss_current_player_ids & ss_previous_player_ids
      ss_destroyed = ss_previous_player_ids - ss_current_player_ids

      dispatch_created_ss(solar_system_id, ss_created, current_metadatas) \
        unless ss_created.blank?

      dispatch_updated_ss(
        solar_system_id, ss_updated, previous_metadatas, current_metadatas
      ) unless ss_updated.blank?

      dispatch_destroyed_ss(solar_system_id, ss_destroyed) \
        unless ss_destroyed.blank?

      ret_val
    end

    # Tracks visibility changes for movement. Given two +LocationPoint+s choose
    # one that would yield more data and pass it to #track_location_changes.
    def track_movement_changes(
      source_location_point, target_location_point, &block
    )
      typesig binding, LocationPoint, LocationPoint, Proc

      if source_location_point.type == Location::SS_OBJECT
        track_location_changes(source_location_point, &block)
      elsif target_location_point.type == Location::SS_OBJECT
        track_location_changes(target_location_point, &block)
      elsif source_location_point.type == Location::SOLAR_SYSTEM
        track_location_changes(source_location_point, &block)
      elsif target_location_point.type == Location::SOLAR_SYSTEM
        track_location_changes(target_location_point, &block)
      else
        block.call
      end
    end

  private

    def dispatch_planet_changes(
      planet, planet_old_observers, planet_new_observers
    )
      # If observers changed, dispatch changed on the planet.
      EventBroker.fire(planet, EventBroker::CHANGED)
      # And if some players were viewing the planet, but they can't
      # anymore, dispatch event to unset their session planet ids.
      cannot_observe_anymore = planet_old_observers - planet_new_observers
      EventBroker.fire(
        Event::PlanetObserversChange.new(planet.id, cannot_observe_anymore),
        EventBroker::CREATED
      ) unless cannot_observe_anymore.blank?
    end

    def dispatch_created_ss(solar_system_id, player_ids, current_metadatas)
      players = Player.find(player_ids)
      row = without_locking do
        SolarSystem.select("x, y, kind, player_id").where(id: solar_system_id).
          c_select_one
      end
      x, y, kind, player_minimal = row["x"], row["y"], row["kind"],
        Player.minimal(row["player_id"])

      EventBroker.fire(
        Event::FowChange::SsCreated.new(
          solar_system_id, x, y, kind, player_minimal, players,
          current_metadatas
        ),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end

    def dispatch_updated_ss(
      solar_system_id, player_ids, previous_metadatas, current_metadatas
    )
      players = Player.find(player_ids).reject do |player|
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
      ) unless players.empty?
    end

    def dispatch_destroyed_ss(solar_system_id, player_ids)
      EventBroker.fire(
        Event::FowChange::SsDestroyed.new(solar_system_id, player_ids),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end
  end
end
