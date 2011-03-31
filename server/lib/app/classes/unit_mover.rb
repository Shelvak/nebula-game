# Class that moves unit from one place to another.
#
# Invokes various methods and sets up callbacks.
#
class UnitMover
  # Move given units from _source_ to _target_, optionally passing through
  # jumpgate specified via _through_.
  #
  # If _avoid_npc_ is set to true units will take longer but safer route
  # if possible.
  #
  # All units listed in _unit_ids_ should belong to same Player specified by
  # _player_id_.
  #
  def self.move(player_id, unit_ids, source, target, avoid_npc=true)
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

    units = Unit.units_for_moving(unit_ids, player_id, source)
    units.each do |type, count|
      kind = CONFIG["units.#{type.underscore}.kind"]
      raise GameLogicError.new(
        "Unit type #{type} should be space unit but was #{kind.inspect}"
      ) unless kind == :space

      find_max_hop_times!(hop_times, type)
      selected_count += count
    end

    raise GameLogicError.new(
      "#{requested_count} units requested to move but only #{
        selected_count} was found for player id #{player_id} in #{
        source}"
    ) unless requested_count == selected_count

    separate_from_old_route(unit_ids, units)

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
    hops = path.map do |location|
      hop = RouteHop.new
      hop.location = LocationPoint.new(
        location['id'].to_i,
        location['type'].to_i,
        location['x'] ? location['x'].to_i : nil,
        location['y'] ? location['y'].to_i : nil
      )
      hop.index = index
      hop.arrives_at = (last_hop.try(:arrives_at) || Time.now) +
        (hop_times[hop.hop_type] * location['time']).round
      
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
    route.save!
    
    first_hop.next = true

    # We now have route id, we can save our hops!
    hops.each do |hop|
      hop.route_id = route.id
      hop.save!
    end

    # Assign units to given route.
    Unit.update_all(["route_id=?", route.id], ["id IN (?)", unit_ids])

    CallbackManager.register(first_hop, CallbackManager::EVENT_MOVEMENT,
      first_hop.arrives_at)
    EventBroker.fire(
      MovementPrepareEvent.new(route, unit_ids),
      EventBroker::MOVEMENT_PREPARE
    )

    route
  end

  # Separate given unit ids from their old route. Supports only one route
  # at a time.
  def self.separate_from_old_route(unit_ids, units)
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
  def self.find_max_hop_times!(hop_times, type)
    type = type.underscore
    [:solar_system, :galaxy].each do |space|
      hop_time = CONFIG.evalproperty(
        "units.#{type}.move.#{space}.hop_time"
      )
      raise "CONFIG[units.#{type}.move.#{space}.hop_time] is nil!" \
        if hop_time.nil?
      hop_times[space] = hop_time if hop_time > hop_times[space]
    end
  end
end