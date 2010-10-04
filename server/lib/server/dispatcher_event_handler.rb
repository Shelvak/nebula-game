# Handles events that should push messages to Dispatcher.
class DispatcherEventHandler
  def initialize(dispatcher)
    @dispatcher = dispatcher
    EventBroker.register(self)
  end

  def fire(object, event_name, reason)
    case event_name
    when EventBroker::CREATED
      handle_created(object, reason)
    when EventBroker::CHANGED
      handle_changed(object, reason)
    when EventBroker::DESTROYED
      handle_destroyed(object, reason)
    when EventBroker::MOVEMENT_PREPARE
      handle_movement_prepare(object)
    when EventBroker::MOVEMENT
      handle_movement(object, reason)
    when EventBroker::FOW_CHANGE
      handle_fow_change(object, reason)
    end
  end

  private
  def handle_created(objects, reason)
    case objects[0]
    when Parts::Object
      player_ids, filter = self.class.resolve_objects(objects)
      player_ids.each do |player_id|
        @dispatcher.push_to_player(
          player_id,
          ObjectsController::ACTION_CREATED,
          {'objects' => objects},
          filter
        )
      end
    else
      raise ArgumentError.new("Don't know how to handle created for #{
        objects.inspect}!")
    end
  end

  def handle_destroyed(objects, reason)
    case objects[0]
    when Parts::Object
      objects = self.class.filter_objects(objects)
      unless objects.blank?
        player_ids, filter = self.class.resolve_objects(objects)

        player_ids.each do |player_id|
          @dispatcher.push_to_player(
            player_id,
            ObjectsController::ACTION_DESTROYED,
            {'objects' => objects},
            filter
          )
        end
      end
    else
      raise ArgumentError.new(
        "Don't know how to handle destroyed for #{objects.inspect}!"
      )
    end
  end

  def handle_changed(objects, reason)    
    object = objects[0]
    case object
    when ResourcesEntry
      object.planet.player.friendly_ids.each do |player_id|
        @dispatcher.push_to_player(
          player_id,
          ResourcesController::ACTION_INDEX,
          {'resources_entry' => object},
          DispatcherPushFilter.new(
            DispatcherPushFilter::PLANET, object.planet_id)
        )
      end
    when Player
      @dispatcher.update_player(object)
      @dispatcher.push_to_player(
        object.id,
        PlayersController::ACTION_SHOW
      )
    when Parts::Object
      objects = self.class.filter_objects(objects)
      unless objects.blank?
        player_ids, filter = self.class.resolve_objects(objects)

        player_ids.each do |player_id|
          @dispatcher.push_to_player(
            player_id,
            ObjectsController::ACTION_UPDATED,
            {'objects' => objects, 'reason' => reason},
            filter
          )
        end
      end
    when Technology
      # Just silently ignore it, we pass stuff manually with this one.
    else
      raise ArgumentError.new(
        "Don't know how to handle changed for #{objects.inspect}!"
      )
    end
  end

  # Handles preparations for unit movement.
  def handle_movement_prepare(movement_prepare_event)
    route = movement_prepare_event.route
    zone_route_hops = route.hops_in_current_zone
    unit_ids = movement_prepare_event.unit_ids

    player_ids, filter = self.class.resolve_location(route.current)
    friendly_player_ids = route.player.friendly_ids

    player_ids.each do |player_id|
      friendly = friendly_player_ids.include?(player_id)
      if friendly
        mode = :normal
        route_hops = zone_route_hops
      else
        mode = :enemy
        route_hops = [zone_route_hops[0]]
      end

      @dispatcher.push_to_player(
        player_id,
        UnitsController::ACTION_MOVEMENT_PREPARE,
        {
          'route' => route.as_json(:mode => mode),
          'unit_ids' => unit_ids,
          'route_hops' => route_hops
        },
        friendly ? nil : filter
      )
    end
  end

  # Handles unit movement.
  # TODO: spec
  def handle_movement(movement_event, reason)
    previous_player_ids = self.class.resolve_location(
      movement_event.previous_location
    )[0]
    current_player_ids, filter = self.class.resolve_location(
      movement_event.current_hop.location
    )

    player = movement_event.route.player
    friendly_player_ids = player.friendly_ids

    # Only dispatch movement to enemy players, players that own these units
    # have their all zone route hops anyways.
    if reason == EventBroker::REASON_IN_ZONE
      # Subtract friendly_player_ids set because they have all the zone
      # movements anyway.
      (
        (previous_player_ids | current_player_ids) - friendly_player_ids
      ).each do |player_id|
        state_change = self.class.state_changed?(player_id,
          previous_player_ids, current_player_ids)

        units = []
        route_hops = []
        hide_id = nil
        # If unit appeared from invisible zone.
        case state_change
        when STATE_CHANGED_TO_VISIBLE
          units = movement_event.route.units
          route_hops = [movement_event.next_hop]
        when STATE_CHANGED_TO_HIDDEN
          hide_id = movement_event.route.id
        when STATE_UNCHANGED
          route_hops = [movement_event.next_hop]
        else
          raise ArgumentError.new("Unknown state change type: #{
            state_change.inspect}")
        end

        dispatch_movement(filter, player_id, units, route_hops, hide_id)
      end
    else
      # Movement was between zones.
      units = movement_event.route.units

      # Dispatch units that arrived at zone and their route hops for their
      # owner or alliance and only next hop otherwise.
      current_player_ids.each do |player_id|
        if friendly_player_ids.include?(player_id)
          dispatch_movement(filter, player_id, units,
            movement_event.route.hops_in_current_zone)
        else
          dispatch_movement(filter, player_id, units,
            [movement_event.next_hop])
        end
      end
    end    
  end

  # Handles fog of war changes
  def handle_fow_change(fow_change_event, reason)
    fow_change_event.player_ids.each do |player_id|
      # Update galaxy map
      @dispatcher.push_to_player(player_id,
        SolarSystemsController::ACTION_INDEX)
    end
  end

  STATE_UNCHANGED = :unchanged
  STATE_CHANGED_TO_VISIBLE = :changed_to_visible
  STATE_CHANGED_TO_HIDDEN = :changed_to_hidden

  # Checks how did state change between locations.
  def self.state_changed?(player_id, previous, current)
    if previous.include?(player_id) && ! current.include?(player_id)
      STATE_CHANGED_TO_HIDDEN
    elsif ! previous.include?(player_id) && current.include?(player_id)
      STATE_CHANGED_TO_VISIBLE
    else
      STATE_UNCHANGED
    end
  end

  # Filter objects to avoid conditions, where we try to notify user about
  # unsupported kinds.
  # 
  # E.g.: units inside buildings are invisible to everyone and should never
  # be included in objects passed to #resolve_objects.
  #
  def self.filter_objects(objects)
    case objects[0]
    when Unit
      objects = objects.reject do |unit|
        ! location_supported?(unit.location)
      end
    end

    objects
  end

  # Supported location types
  SUPPORTED_TYPES = [Location::GALAXY, Location::SOLAR_SYSTEM,
    Location::PLANET]
  def self.location_supported?(location)
    SUPPORTED_TYPES.include?(location.type)
  end

  # Resolves player ids that should be notified about events in _location_.
  # Also returns filter for that location.
  def self.resolve_location(location)
    raise ArgumentError.new("Unknown location type #{location.type}!") \
      unless location_supported?(location)

    case location.type
    when Location::GALAXY
      [
        FowGalaxyEntry.observer_player_ids(
          location.id,
          location.x,
          location.y
        ),
        nil
      ]
    when Location::SOLAR_SYSTEM
      [
        FowSsEntry.observer_player_ids(location.id),
        DispatcherPushFilter.new(
          DispatcherPushFilter::SOLAR_SYSTEM, location.id)
      ]
    when Location::PLANET
      [
        location.object.observer_player_ids,
        DispatcherPushFilter.new(
          DispatcherPushFilter::PLANET, location.id)
      ]
    end
  end

  # Resolves player ids that should be notified about _objects_ and that
  # object filter. First item will be used for resolving.
  def self.resolve_objects(objects)
    object = objects.is_a?(Array) ? objects[0] : objects

    case object
    when Building
      [
        object.planet.observer_player_ids,
        DispatcherPushFilter.new(
          DispatcherPushFilter::PLANET, object.planet_id)
      ]
    when Unit
      resolve_location(object.location)
    when Route
      [object.player.friendly_ids, nil]
    when Planet
      [
        SolarSystem.observer_player_ids(object.solar_system_id),
        DispatcherPushFilter.new(
          DispatcherPushFilter::SOLAR_SYSTEM, object.solar_system_id)
      ]
    when ConstructionQueueEntry
      planet = object.constructor.planet
      [
        planet.player.friendly_ids,
        DispatcherPushFilter.new(DispatcherPushFilter::PLANET, planet.id)
      ]
    when Notification, ClientQuest, QuestProgress, ObjectiveProgress
      [[object.player_id], nil]
    else
      raise ArgumentError.new("Don't know how to resolve player ids for #{
        object.inspect}!")
    end
  end

  # Dispatches movement action to player
  def dispatch_movement(filter, player_id, units, route_hops, hide_id=nil)
    @dispatcher.push_to_player(
      player_id,
      UnitsController::ACTION_MOVEMENT,
      {'units' => units, 'route_hops' => route_hops, 'hide_id' => hide_id},
      filter
    )
  end
end
