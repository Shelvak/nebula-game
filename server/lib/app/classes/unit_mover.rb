# Class that moves unit from one place to another.
#
# Invokes various methods and sets up callbacks.
#
class UnitMover
  class << self
    # Calculate arrival date and hop count for units that would travel 
    # from source to target.
    # 
    # Returns: [arrival_date, hop_count]
    #
    def move_meta(player_id, unit_ids, source, target, avoid_npc=true)
      units, route, hops = calculate_route(
        player_id, unit_ids, source, target, avoid_npc, 1)

      [route.arrives_at, hops.size]
    end

    # Move given units from _source_ to _target_, optionally passing through
    # jumpgate specified via _through_.
    #
    # If _avoid_npc_ is set to true units will take longer but safer route
    # if possible.
    #
    # All units listed in _unit_ids_ should belong to same Player specified by
    # _player_id_.
    #
    def move(player_id, unit_ids, source, target, avoid_npc=true,
        speed_modifier=1)
      units, route, hops = calculate_route(
        player_id, unit_ids, source, target, avoid_npc, speed_modifier)

      separate_from_old_route(unit_ids, units)
      route.save!

      # We now have route id, we can save our hops!
      hops.each do |hop|
        hop.route_id = route.id
        hop.save!
      end

      # Assign units to given route.
      Unit.update_all(["route_id=?", route.id], ["id IN (?)", unit_ids])

      CallbackManager.register(hops[0], CallbackManager::EVENT_MOVEMENT,
        hops[0].arrives_at)
      EventBroker.fire(
        MovementPrepareEvent.new(route, unit_ids),
        EventBroker::MOVEMENT_PREPARE
      )

      route
    end

    private
    # Calculate route and its hops.
    def calculate_route(player_id, unit_ids, source, target, avoid_npc,
        speed_modifier)
      raise GameLogicError.new("Cannot move, source == target!") \
        if source == target
      raise GameLogicError.new(
        "Cannot land in #{target}!"
      ) if target.is_a?(SsObject) && ! target.landable?

      requested_count = unit_ids.size
      selected_count = 0

      hop_times = {
        :solar_system => 0,
        :galaxy => 0
      }

      decreases = player_id.nil? \
        ? {} \
        : TechModApplier.apply(
          TechTracker.query_active(player_id, 'movement_time_decrease'),
          'movement_time_decrease'
        )

      units = Unit.units_for_moving(unit_ids, player_id, source)
      units.each do |type, count|
        kind = CONFIG["units.#{type.underscore}.kind"]
        raise GameLogicError.new(
          "Unit type #{type} should be space unit but was #{kind.inspect}"
        ) unless kind == :space

        find_max_hop_times!(hop_times, type, 
          1 - (decreases["Unit::#{type}"] || 0))
        selected_count += count
      end

      raise GameLogicError.new(
        "#{requested_count} units requested to move but only #{
          selected_count} was found for player id #{player_id} in #{
          source}"
      ) unless requested_count == selected_count

      route = Route.new
      route.source = source.client_location
      route.current = source.client_location
      route.target = target.client_location
      route.player_id = player_id
      route.cached_units = units

      path = SpaceMule.instance.find_path(source, target, avoid_npc)
      first_hop = nil
      last_hop = nil
      index = 0
      hops = path.map do |server_location|
        hop = RouteHop.new
        x, y = server_location.coords.empty? \
          ? [nil, nil] \
          : [server_location.coords.get.x, server_location.coords.get.y]
        hop.location = LocationPoint.new(
          server_location.id.to_i,
          server_location.kind.id,
          x,
          y
        )
        hop.index = index

        hop.arrives_at = (last_hop.try(:arrives_at) || Time.now) +
          (hop_times[hop.hop_type] * server_location.time_multiplier *
            speed_modifier).round

        # Set previous hop as jump hop.
        if last_hop && last_hop.location.type != hop.location.type
          last_hop.jumps_at = hop.arrives_at
        end

        index += 1
        first_hop ||= hop
        last_hop = hop

        hop
      end

      route.first_hop = first_hop.arrives_at
      route.arrives_at = last_hop.arrives_at

      first_hop.next = true

      [units, route, hops]
    end

    # Separate given unit ids from their old route. Supports only one route
    # at a time.
    def separate_from_old_route(unit_ids, units)
      route_ids = Unit.distinct_route_ids(unit_ids)
      raise GameLogicError.new(
        "Cannot separate units from more than 1 route! Route ids: #{
        route_ids.inspect}"
      ) if route_ids.size > 1

      route_id = route_ids[0]
      unless route_id.nil?
        Route.find(route_id).subtract_from_cached_units!(units)
      end
    end

    # Find and store hop times for given unit _type_ into _hop_times_ hash.
    def find_max_hop_times!(hop_times, type, multiplier)
      type = type.underscore
      [:solar_system, :galaxy].each do |space|
        hop_time = (CONFIG.evalproperty(
          "units.#{type}.move.#{space}.hop_time"
        ) * multiplier).round
        raise "CONFIG[units.#{type}.move.#{space}.hop_time] is nil!" \
          if hop_time.nil?
        hop_times[space] = hop_time if hop_time > hop_times[space]
      end
    end
  end
end