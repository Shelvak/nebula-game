class UnitsController < GenericController
  ACTION_NEW = 'units|new'
  # Orders constructor to create new unit. This can be invoked by either
  # client or pushed by server.
  #
  # Invocation: by client
  #
  # Parameters:
  # - type (String): type of a unit, i. e. "Trooper"
  # - count (Fixnum): how much of that unit to build
  # - constructor_id (Fixnum): which constructor should build it
  #
  # Response: None
  #
  def action_new
    param_options :required => %w{type count constructor_id}

    constructor = Building.find(params['constructor_id'],
      :include => :planet)
    raise ActiveRecord::RecordNotFound \
      if constructor.planet.player_id != player.id

    constructor.construct!("Unit::#{params['type']}",
      {:galaxy_id => player.galaxy_id},
      params['count'].to_i)

    # Flag as handled
    true
  end

  ACTION_UPDATE = 'units|update'
  # Mass updates flanks and stances of player units.
  #
  # Invocation: by client
  #
  # Parameters:
  # - updates (Hash): hash of unit_id => [flank, stance] pairs.
  #
  # Response: None
  #
  def action_update
    param_options :required => %w{updates}
    Unit.update_combat_attributes(player.id, params['updates'])

    true
  end

  ACTION_ATTACK = 'units|attack'
  # Attacks an NPC building in player planet.
  #
  # Invocation: by client
  #
  # Params:
  # - planet_id (Fixnum): id of a planet which player owns
  # - target_id (Fixnum): id of a NPC building which player wants to attack
  # - unit_ids (Array of Fixnum): ids of units that should participate in
  # the battle.
  #
  # Response: pushes units|attack
  #
  # Invocation: by server
  #
  # Params:
  # - notification_id (Fixnum): ID of the notification for this player
  # that notifies about this battle. The notification itself will be pushed
  # via notifications|new.
  #
  # Response:
  # - notification_id
  #
  # <strong>Flow of control</strong>
  #
  # 1. Client invokes units|attack. Combat is simulated and notification is
  # created. Also units|attack is pushed.
  # 2. Notification is pushed via notifications|new.
  # 3. Pushed units|attack is processed and reply is sent to the server.
  #
  def action_attack
    if pushed?
      param_options :required => %w{notification_id}
      respond :notification_id => params['notification_id']
    else
      param_options :required => %w{planet_id target_id unit_ids}
      raise ControllerArgumentError.new("unit_ids cannot be empty!") \
        if params['unit_ids'].blank?

      planet = SsObject::Planet.for_player(player.id).find(
        params['planet_id'])
      target = planet.buildings.find(params['target_id'])
      raise ActiveRecord::RecordNotFound.new(
        "#{params['target_id']} must be NPC building!"
      ) unless target.npc?

      player_units = Unit.in_location(planet.location_attrs).
        where(:player_id => player.id).find(params['unit_ids'])

      unless params['unit_ids'].size == player_units.size
        missing_ids = params['unit_ids'] - player_units.map(&:id)
        raise ActiveRecord::RecordNotFound.new(
          "Cannot find all units (missing ids: #{missing_ids.join(",")
            } in planet #{planet}!"
        )
      end

      assets = Combat.run_npc!(planet, player_units, target)

      # Destroy NPC building if there are no more units there.
      if target.units.blank?
        Objective::DestroyNpcBuilding.progress(target, player)
        target.destroy!
      end

      # We are pushing this to invert flow of messages. If we respond
      # directly, player would get response first and pushed notification
      # later.
      push(action,
        'notification_id' => assets.notification_ids[player.id])
    end
  end

  # Calculate arrival date and number of hop times of selected space units.
  # All units must be space units, ground units cannot be moved. 
  # All units also must be in same source location.
  #
  # Parameters:
  # - unit_ids (Array of Fixnum): unit ids that should be moved
  # - source (Hash): source location in such format:
  #     {
  #       'location_id' => location_id,
  #       'location_type' => Location::GALAXY (0) ||
  #         Location::SOLAR_SYSTEM (1) || Location::SS_OBJECT (2),
  #       'location_x' => location_x,
  #       'location_y' => location_y,
  #     }
  #
  #     If type is +GALAXY+ or +SOLAR_SYSTEM+ then _location_x_ and
  #     _location_y_ should be coordinates in location. If type is +SS_OBJECT+
  #     then both is +nil+.
  #
  #     _location_x_, _location_y_ represents _x_ and _y_ in +GALAXY+ type.
  #     _location_x_, _location_y_ represents _position_ and _angle_ in
  #     +SOLAR_SYSTEM+ type.
  #
  # - target (Hash) - target location. Format same as source.
  # - avoid_npc (Boolean) - should we avoid NPC units when flying?
  #
  # Response:
  # - arrival_date (Time): when would these units arrive.
  # - hop_count (Fixnum): number of hops to get to the target
  #
  def action_move_meta
    param_options :required => %w{unit_ids source target avoid_npc}

    source, target = resolve_location

    arrival_date, hop_count = UnitMover.move_meta(
      player.id, params['unit_ids'], source, target, params['avoid_npc']
    )

    respond :arrival_date => arrival_date, :hop_count => hop_count
  end

  ACTION_MOVE = 'units|move'
  # Initiate movement of selected space units. All units must be space
  # units, ground units cannot be moved. All units also
  # must be in same source location.
  #
  # Unit speed can be controlled via _speed_modifier_. If it is < 1, creds
  # will be used for player. Amount of creds is:
  #   ((1 - params['speed_modifier']) * CONFIG['creds.move.speed_up']).round
  #
  # Invocation: by client
  #
  # Parameters:
  # same as units|arrival_date +
  # - speed_modifier (Float): 1 means no speed change
  #
  # Response: None
  #
  def action_move
    param_options :required => %w{unit_ids source target avoid_npc
      speed_modifier}

    source, target = resolve_location

    sm = MoveSpeedModifier.new(params['speed_modifier'])
    
    ActiveRecord::Base.transaction do
      sm.deduct_creds!(player, params['unit_ids'], source, target, 
        params['avoid_npc'])

      UnitMover.move(
        player.id, params['unit_ids'], source, target, params['avoid_npc'],
        sm.to_f
      )
    end
  end

  ACTION_MOVEMENT_PREPARE = 'units|movement_prepare'
  # Notifies client about units preparing for movement.
  #
  # If you're friendly - you will be supplied full routes and all the route
  # hops in the zone.
  #
  # If you're not - Route will only have id and current location, see
  # Route#as_json for more info. Additionally you will only get next route
  # hop.
  #
  # Invocation: by server
  #
  # Parameters:
  # - route (Hash) - Route#as_json
  # - unit_ids (Fixnum[])
  # - route_hops (RouteHop[])
  #
  # Response:
  # - route (Hash) - Route#as_json
  # - unit_ids (Fixnum[]) - Array of unit ids that should be assigned to
  # route.
  # - route_hops (RouteHop[]) - Route hops for current zone.
  #
  def action_movement_prepare
    param_options :required => %w{route unit_ids route_hops}
    only_push!

    respond :route => params['route'], :unit_ids => params['unit_ids'],
      :route_hops => params['route_hops']
  end

  ACTION_MOVEMENT = 'units|movement'
  # Notifies client about unit movement.
  #
  # If those movements are in zone and you are route owner or from same
  # alliance, you won't be notified because you already have them in your
  # wanted zone.
  #
  # Otherwise there are three cases based on units visibility state:
  # 1. State did not change, units are still visible: you would be sent next
  # route hop of the given route.
  # 2. Units became visible: they were in hidden zone and entered visible
  # one. units will be array with units, route_hops will have the next hop.
  #
  # If those movements are between zones (i.e. galaxy->solar system) you
  # will get all the units and route hops as declared by game logic.
  #
  # Invocation: by server
  #
  # Parameters:
  # - units
  # - route_hops
  #
  # Response:
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - route_hops (RouteHop[]): Array of hop objects that should be visible
  # to you. If switching zones, always include hop to which you arrive in new
  # zone.
  #
  def action_movement
    param_options :required => {:units => Array, :route_hops => Array}
    only_push!

    resolver = StatusResolver.new(player)

    respond \
      :units => params['units'].
        map { |unit| unit.as_json(:perspective => resolver) },
      :players => Player.minimal_from_objects(params['units']),
      :route_hops => params['route_hops']
  end

  # Deploy a deployable unit onto +SsObject+.
  #
  # Invocation: by client
  #
  # Parameters:
  # - planet_id (Fixnum): +SsObject+ id where building will be built and
  # where unit is.
  # - x (Fixnum): _x_ coordinate of +Building+.
  # - y (Fixnum): _y_ coordinate of +Building+.
  # - unit_id (Fixnum): +Unit+ id that needs to be deployed
  #
  # Response: None
  #
  def action_deploy
    param_options :required => %w{planet_id unit_id x y}

    planet = SsObject::Planet.where(:player_id => player.id).find(
      params['planet_id'])
    unit = Unit.where(:player_id => player.id).find(params['unit_id'])
    raise ActiveRecord::RecordNotFound.new(
      "#{unit} must be in #{planet} or other unit, which is in planet!"
    ) unless unit.location == planet.location_point || (
      unit.location.type == Location::UNIT &&
        unit.location.object.location == planet.location_point
    )

    unit.deploy(planet, params['x'], params['y'])

    true
  end

  # Loads selected units to +Unit+. Loaded units and transporter must be
  # in same location.
  #
  # Invocation: by client
  #
  # Parameters:
  # - unit_ids (Fixnum[]): IDs of units that are going to be loaded.
  # - transporter_id (Fixnum): ID of transporter Unit.
  #
  # Response: None
  #
  # Pushes:
  # - objects|updated with transporter
  # - objects|updates (reason 'loaded') with units that were loaded into
  # transporter.
  #
  def action_load
    param_options :required => {:unit_ids => Array, :transporter_id => Fixnum}

    transporter = Unit.where(:player_id => player.id).find(
      params['transporter_id'])

    units = Unit.where(
      :player_id => player.id, :id => params['unit_ids']
    )
    raise ActiveRecord::RecordNotFound.new(
      "Cannot find all requested units, perhaps some does not belong to" +
        " player? Requested #{params['unit_ids'].size}, found #{
        units.size}."
    ) if units.size < params['unit_ids'].size

    transporter.load(units)

    true
  end

  # Loads/unloads resources into transporter.
  #
  # Transporter must be in planet, solar system point or galaxy point.
  #
  # Invocation: by client
  #
  # Parameters:
  # - transporter_id (Fixnum): ID of transporter Unit.
  # - metal (Float): Amount of metal to load. Pass negative to unload.
  # - energy (Float): Amount of energy to load. Pass negative to unload.
  # - zetium (Float): Amount of zetium to load. Pass negative to unload.
  #
  # Response: None
  #
  # Pushes:
  # - objects|updated with transporter
  # If in planet:
  # - objects|updated with planet
  # If in SS or Galaxy point:
  # - objects|updated or objects|destroyed with wreckage
  #
  def action_transfer_resources
    param_options :required => {
      :transporter_id => Fixnum, :metal => [Fixnum, Float],
      :energy => [Fixnum, Float], :zetium => [Fixnum, Float]
    }

    transporter = Unit.where(:player_id => player.id).find(
      params['transporter_id'])

    # Check if we can load/unload things.
    if transporter.location.type == Location::SS_OBJECT
      planet = transporter.location.object
      raise GameLogicError.new(
        "Cannot load resources from planet: not owner and it's not empty!"
      ) if (
        params['metal'] > 0 || params['energy'] > 0 || params['zetium'] > 0
      ) && ! (planet.player_id == player.id)
      # This will be enabled when player protection will be implemented.
      # ! (planet.player_id == player.id || planet.player_id.nil?)
    end

    transporter.transfer_resources!(params['metal'], params['energy'],
      params['zetium'])

    true
  end

  # Unloads selected units to +SsObject+. Transporter must be in +Planet+ to
  # perform this action.
  #
  # Invocation: by client
  #
  # Parameters:
  # - unit_ids (Fixnum[]): IDs of units that are going to be unloaded.
  # - transporter_id (Fixnum): ID of transporter Unit.
  #
  # Response: None
  #
  # Pushes:
  # - objects|updated with transporter
  # - objects|updates (reason 'unloaded') with units that were unloaded from
  # transporter.
  #
  def action_unload
    param_options :required => {:unit_ids => Array, 
      :transporter_id => Fixnum}

    transporter = Unit.where(:player_id => player.id).find(
      params['transporter_id'])
    raise GameLogicError.new(
      "To unload #{transporter} must be in planet, but was it #{
        transporter.location_point}!"
    ) unless transporter.location.type == Location::SS_OBJECT

    location = transporter.location.object
    units = transporter.units.find(params['unit_ids'])
    transporter.unload(units, location)

    true
  end

  # Shows units contained in other unit.
  #
  # Invoked: by client
  #
  # Parameters:
  # - unit_id (Fixnum)
  #
  # Response:
  # - units (Unit[]): Units container in that unit.
  #
  def action_show
    param_options :required => %w{unit_id}

    transporter = Unit.where(:player_id => player.friendly_ids).find(
      params['unit_id'])

    respond :units => transporter.units.map(&:as_json)
  end

  ACTION_HEAL = 'units|heal'
  # Heals requested units to full HP. Sets cooldown on healing center.
  # Reduces resources in planet.
  #
  # Invocation: by client
  #
  # Parameters:
  # - building_id (Fixnum): id of +Building::HealingCenter+.
  # - unit_ids (Fixnum[]): array of unit ids to heal.
  #
  # Response: None
  #
  def action_heal
    param_options :required => %w{building_id unit_ids}

    building = Building::HealingCenter.find(params['building_id'])
    raise GameLogicError.new("Planet must belong to #{player}!") unless \
      building.planet.player_id == player.id

    building.heal!(Unit.find(params['unit_ids']))
  end

  # Dismisses players units. Releases population. Gives player resources
  # for dismissed units.
  #
  # Invocation: by client
  #
  # Parameters:
  # - planet_id (Fixnum): ID of players planet where all the units are
  # - unit_ids (Fixnum[]): IDs of units to be dismissed.
  #
  # Response: None
  #
  def action_dismiss
    param_options :required => %w{planet_id unit_ids}

    planet = SsObject::Planet.where(:player_id => player.id).find(
      params['planet_id'])
    
    Unit.dismiss_units(planet, params['unit_ids'])
  end

  private
  def resolve_location
    source = Location.find_by_attrs(params['source'].symbolize_keys)
    target = Location.find_by_attrs(params['target'].symbolize_keys)
    raise GameLogicError.new("Target #{target} is not visible for #{
      player}!") unless Location.visible?(player, target)

    [source, target]
  end
end