# Handles events that should push messages to Dispatcher.
class DispatcherEventHandler
  def initialize(dispatcher)
    @dispatcher = dispatcher
    EventBroker.register(self)
  end

  def fire(object, event_name, reason)
    case event_name
    when EventBroker::CREATED
      Handler::Created.handle(@dispatcher, object, reason)
    when EventBroker::CHANGED
      Handler::Changed.handle(@dispatcher, object, reason)
    when EventBroker::DESTROYED
      Handler::Destroyed.handle(@dispatcher, object, reason)
    when EventBroker::MOVEMENT_PREPARE
      handle_movement_prepare(object)
    when EventBroker::MOVEMENT
      handle_movement(object, reason)
    when EventBroker::FOW_CHANGE
      handle_fow_change(object, reason)
    else
      raise ArgumentError.new("Unknown event: '#{event_name}'!")
    end
  end

  private
  # Handles preparations for unit movement.
  def handle_movement_prepare(movement_prepare_event)
    route = movement_prepare_event.route
    zone_route_hops = route.hops_in_current_zone
    unit_ids = movement_prepare_event.unit_ids

    player = route.player
    friendly_player_ids = player.nil? ? [] : player.friendly_ids

    player_ids, filter = LocationResolver.resolve_movement(
      route.current, friendly_player_ids
    )

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
        # Client always uses route when player is friendly even if the route
        # is not in currently viewable zone.
        friendly ? nil : filter
      )
    end
  end

  # Handles unit movement.
  # TODO: spec
  def handle_movement(movement_event, reason)
    debug "Handling movement event (reason: #{reason})" do
      player = movement_event.route.player
      friendly_player_ids = player.nil? ? [] : player.friendly_ids
      next_hop = movement_event.next_hop

      previous_player_ids, _ = LocationResolver.resolve_movement(
        movement_event.previous_location, friendly_player_ids
      )
      current_player_ids, filter = LocationResolver.resolve_movement(
        movement_event.current_hop.location, friendly_player_ids
      )

      debug "previous_player_ids: #{previous_player_ids.inspect}"
      debug "current_player_ids: #{current_player_ids.inspect}"
      debug "friendly_player_ids: #{friendly_player_ids.inspect}"
      debug "filter: #{filter}"

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
          # Nullify next hop if it leads to other zone - client doesn't want
          # to know about that.
          current_hop = movement_event.current_hop
          jumps_at = nil
          next_hop = nil \
            if next_hop &&
            current_hop.location.type != next_hop.location.type
          # If unit appeared from invisible zone.
          case state_change
          when STATE_CHANGED_TO_VISIBLE
            units = movement_event.route.units
            route_hops = [next_hop].compact
            jumps_at = movement_event.route.jumps_at
          when STATE_UNCHANGED
            # Return if we have no units to show/hide and no route hops
            return unless next_hop
            route_hops = [next_hop]
          else
            raise ArgumentError.new("Unknown state change type: #{
              state_change.inspect}")
          end

          dispatch_movement(filter, player_id, units, route_hops, jumps_at)
        end
      when EventBroker::REASON_BETWEEN_ZONES
        # Movement was between zones.
        units = movement_event.route.units

        # Dispatch units that arrived at zone and their route hops for their
        # owner or alliance and only next hop otherwise.
        current_player_ids.each do |player_id|
          if friendly_player_ids.include?(player_id)
            dispatch_movement(filter, player_id, units,
              movement_event.route.hops_in_current_zone,
              movement_event.route.jumps_at)
          else
            dispatch_movement(filter, player_id, units,
              # This movement could be last hop, so next hop would be nil.
              [movement_event.next_hop].compact,
              movement_event.route.jumps_at)
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
        if fow_change_event.is_a?(Event::FowChange::SsDestroyed)
          @dispatcher.push_to_player(player_id,
            ObjectsController::ACTION_DESTROYED,
            {
              'objects' => [fow_change_event.metadata],
              'reason' => nil
            }
          )
        elsif fow_change_event.is_a?(Event::FowChange::SsCreated)
          # Create single solar system
          @dispatcher.push_to_player(player_id,
            ObjectsController::ACTION_CREATED,
            {
              'objects' => [fow_change_event.metadatas[player_id]],
              'reason' => nil
            }
          )
        else
          # Update single solar system
          @dispatcher.push_to_player(player_id,
            ObjectsController::ACTION_UPDATED,
            {
              'objects' => [fow_change_event.metadatas[player_id]],
              'reason' => nil
            }
          )
        end
      when EventBroker::REASON_GALAXY_ENTRY
        # Update galaxy map
        @dispatcher.push_to_player(player_id,
          GalaxiesController::ACTION_SHOW)
      end
    end
  end

  STATE_UNCHANGED = :unchanged
  STATE_CHANGED_TO_VISIBLE = :changed_to_visible

  # Checks how did state change between locations.
  def self.state_changed?(player_id, previous, current)
    if ! previous.include?(player_id) && current.include?(player_id)
      STATE_CHANGED_TO_VISIBLE
    else
      STATE_UNCHANGED
    end
  end

  # Dispatches movement action to player
  def dispatch_movement(filter, player_id, units, route_hops, jumps_at)
    @dispatcher.push_to_player(
      player_id,
      UnitsController::ACTION_MOVEMENT,
      {'units' => units, 'route_hops' => route_hops, 'jumps_at' => jumps_at},
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
