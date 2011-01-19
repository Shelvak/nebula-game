# Handles events that should push messages to Dispatcher.
class DispatcherEventHandler
  # Objects were changed
  CONTEXT_CHANGED = :changed
  # Objects were destroyed
  CONTEXT_DESTROYED = :destroyed

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
    object = objects[0]
    if object.is_a? Parts::Object
      player_ids, filter = self.class.resolve_objects(objects, reason)
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
    object = objects[0]
    if object.is_a? Parts::Object
      objects = self.class.filter_objects(objects)
      unless objects.blank?
        player_ids, filter = self.class.resolve_objects(objects, reason,
          CONTEXT_DESTROYED)

        player_ids.each do |player_id|
          @dispatcher.push_to_player(
            player_id,
            ObjectsController::ACTION_DESTROYED,
            {'objects' => objects, 'reason' => reason},
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
    # Case matching doesn't work sometimes
    if object.is_a? Player
      @dispatcher.update_player(object) if @dispatcher.connected?(object.id)
      @dispatcher.push_to_player(
        object.id,
        PlayersController::ACTION_SHOW
      )
    elsif object.is_a? ConstructionQueue::Event
      planet = object.constructor.planet
      @dispatcher.push_to_player(
        planet.player_id,
        ConstructionQueuesController::ACTION_INDEX,
        {'constructor_id' => object.constructor_id},
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
      )
    elsif object.is_a? Parts::Object
      if reason == EventBroker::REASON_OWNER_CHANGED
        old_id, new_id = object.player_id_change
        [old_id, new_id].each do |player_id|
          @dispatcher.push_to_player(
            player_id,
            PlanetsController::ACTION_PLAYER_INDEX
          ) unless player_id.nil?
        end
      end

      objects = self.class.filter_objects(objects)
      unless objects.blank?
        player_ids, filter = self.class.resolve_objects(objects, reason,
          CONTEXT_CHANGED)

        player_ids.each do |player_id|
          @dispatcher.push_to_player(
            player_id,
            ObjectsController::ACTION_UPDATED,
            {'objects' => objects, 'reason' => reason},
            filter
          )
        end
      end
    elsif object.is_a? Technology
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
        # zone_route_hops may be blank, so [0] would return nil
        route_hops = [zone_route_hops[0]].compact
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
    debug "Handling movement event (reason: #{reason})" do
      previous_player_ids, previous_filter = self.class.resolve_location(
        movement_event.previous_location
      )
      current_player_ids, current_filter = self.class.resolve_location(
        movement_event.current_hop.location
      )

      player = movement_event.route.player
      friendly_player_ids = player.friendly_ids
      next_hop = movement_event.next_hop
      # We need previous and current filters to ensure that we always get
      # the message
      # If we only use current filter, then it wont be sent when:
      # * galaxy -> ss, but ss is not selected
      # * ss -> planet, but planet is not selected.
      #
      # It fails other way around if only previous filter is used.
      filters = [previous_filter, current_filter]

      debug "previous_player_ids: #{previous_player_ids.inspect}"
      debug "current_player_ids: #{current_player_ids.inspect}"
      debug "friendly_player_ids: #{friendly_player_ids.inspect}"
      debug "previous_filter: #{previous_filter}"
      debug "current_filter: #{current_filter}"

      # Only dispatch movement to enemy players, players that own these units
      # have their all zone route hops anyways.
      case reason
      when EventBroker::REASON_IN_ZONE
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
          # Nullify next hop if it leads to other zone - client doesn't want
          # to know about that.
          current_hop = movement_event.current_hop
          next_hop = nil \
            if next_hop &&
            current_hop.location.type != next_hop.location.type
          # If unit appeared from invisible zone.
          case state_change
          when STATE_CHANGED_TO_VISIBLE
            units = movement_event.route.units
            route_hops = [next_hop].compact
          when STATE_CHANGED_TO_HIDDEN
            hide_id = movement_event.route.id
          when STATE_UNCHANGED
            # Return if we have no units to show/hide and no route hops
            return unless next_hop
            route_hops = [next_hop]
          else
            raise ArgumentError.new("Unknown state change type: #{
              state_change.inspect}")
          end

          dispatch_movement(filters, player_id, units, route_hops,
            hide_id)
        end
      when EventBroker::REASON_BETWEEN_ZONES
        # Movement was between zones.
        units = movement_event.route.units

        # Dispatch units that arrived at zone and their route hops for their
        # owner or alliance and only next hop otherwise.
        current_player_ids.each do |player_id|
          if friendly_player_ids.include?(player_id)
            dispatch_movement(filters, player_id, units,
              movement_event.route.hops_in_current_zone)
          else
            dispatch_movement(filters, player_id, units,
              # This movement could be last hop, so next hop would be nil
              [movement_event.next_hop].compact)
          end
        end
      else
        raise ArgumentError.new(
          "Movement event #{movement_event} had unknown reason #{
          reason.inspect}!"
        )
      end
    end
  end

  # Handles fog of war changes
  def handle_fow_change(fow_change_event, reason)
    fow_change_event.player_ids.each do |player_id|
      case reason
      when EventBroker::REASON_SS_ENTRY
        # Update single solar system
        @dispatcher.push_to_player(player_id,
          ObjectsController::ACTION_UPDATED,
          {
            'objects' => [fow_change_event.metadatas[player_id]],
            'reason' => nil
          }
        )
      when EventBroker::REASON_GALAXY_ENTRY
        # Update galaxy map
        @dispatcher.push_to_player(player_id,
          GalaxiesController::ACTION_SHOW)
      end
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
  # E.g.: units inside other units are invisible to everyone and should
  # never be included in objects passed to #resolve_objects.
  #
  def self.filter_objects(objects)
#    case objects[0]
#    when Unit
#      objects = objects.reject do |unit|
#        ! location_supported?(unit.location)
#      end
#    end

    objects
  end

  # Supported location types
  SUPPORTED_TYPES = [Location::GALAXY, Location::SOLAR_SYSTEM,
    Location::SS_OBJECT, Location::UNIT, Location::BUILDING]
  def self.location_supported?(location)
    SUPPORTED_TYPES.include?(location.type)
  end

  # Resolves player ids that should be notified about events in _location_.
  # Also returns filter for that location.
  def self.resolve_location(location)
    debug "Resolving pids & filter for #{location}" do
      raise ArgumentError.new("Unknown location type #{location.type}!") \
        unless location_supported?(location)

      case location.type
      when Location::GALAXY
        [location.object.observer_player_ids, nil]
      when Location::SOLAR_SYSTEM
        [
          FowSsEntry.observer_player_ids(location.id),
          DispatcherPushFilter.new(
            DispatcherPushFilter::SOLAR_SYSTEM, location.id)
        ]
      when Location::SS_OBJECT
        [
          location.object.observer_player_ids,
          DispatcherPushFilter.new(
            DispatcherPushFilter::SS_OBJECT, location.id)
        ]
      when Location::UNIT
        unit = location.object
        parent = unit.location.object
        raise "Support for dispatching when parent is #{parent
          } is not supported when type is Location::UNIT" \
          unless parent.is_a?(SsObject::Planet)
        [
          parent.observer_player_ids,
          DispatcherPushFilter.new(
            DispatcherPushFilter::SS_OBJECT, parent.id)
        ]
      when Location::BUILDING
        building = location.object
        [
          building.observer_player_ids,
          DispatcherPushFilter.new(
            DispatcherPushFilter::SS_OBJECT, building.planet_id)
        ]
      end
    end
  end

  # Resolves player ids that should be notified about _objects_ and that
  # object filter. First item will be used for resolving.
  #
  # Resolver behavior can be altered by providing different context.
  #
  def self.resolve_objects(objects, reason, context=nil)
    object = objects.is_a?(Array) ? objects[0] : objects

    case object
    when Building
      [
        object.planet.observer_player_ids,
        DispatcherPushFilter.new(
          DispatcherPushFilter::SS_OBJECT, object.planet_id)
      ]
    when Unit, Wreckage
      resolve_location(object.location)
    when Route
      case context
      when CONTEXT_CHANGED
        [object.player.friendly_ids, nil]
      when CONTEXT_DESTROYED
        player_ids, filter = resolve_location(object.current)
        player_ids += object.player.friendly_ids
        [player_ids.uniq, nil]
      else
        raise ArgumentError.new(
          "Unknown Route context for objects resolver: #{context.inspect}")
      end
    when SsObject
      # Only owner should know about this change.
      if object.is_a?(SsObject::Planet) &&
          reason == EventBroker::REASON_RESOURCES_CHANGED
        player_ids = [object.player_id]
      else
        player_ids = SolarSystem.observer_player_ids(object.solar_system_id)
      end
      [
        player_ids,
        DispatcherPushFilter.new(
          DispatcherPushFilter::SOLAR_SYSTEM, object.solar_system_id)
      ]
    when ConstructionQueueEntry
      planet = object.constructor.planet
      [
        planet.player.friendly_ids,
        DispatcherPushFilter.new(DispatcherPushFilter::SS_OBJECT, planet.id)
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

  def debug(message, &block); self.class.debug(message, &block); end

  def self.debug(message, &block)
    if block
      LOGGER.block message, {:level => :debug, 
        :server_name => "DispatcherEventHandler"}, &block
    else
      LOGGER.debug message, "DispatcherEventHandler"
    end
  end
end
