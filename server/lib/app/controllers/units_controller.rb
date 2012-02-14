class UnitsController < GenericController
  # Orders constructor to create new unit. This can be invoked by either
  # client or pushed by server.
  #
  # Invocation: by client
  #
  # Parameters:
  # - type (String): type of a unit, i. e. "Trooper"
  # - count (Fixnum): how much of that unit to build
  # - constructor_id (Fixnum): which constructor should build it
  # - prepaid (Boolean): are these units paid for?
  #
  # Response: None
  #
  ACTION_NEW = 'units|new'

  NEW_OPTIONS = logged_in + required(
    :type => String, :count => Fixnum, :constructor_id => Fixnum,
    :prepaid => Boolean
  )
  def self.new_scope(m)
    constructor = Building.find(m.params['constructor_id'], :include => :planet)
    scope.planet(constructor.planet_id)
  rescue ActiveRecord::RecordNotFound => e
    raise Dispatcher::UnresolvableScope, e.message, e.backtrace
  end
  def self.new_action(m)
    raise GameLogicError.new(
      "Cannot build new building without resources unless VIP!"
    ) unless m.params['prepaid'] || m.player.vip?

    constructor = Building.find(m.params['constructor_id'], :include => :planet)
    raise ActiveRecord::RecordNotFound.new(
      "Cannot construct new units in non-owned planets!"
    ) if constructor.planet.player_id != m.player.id

    constructor.construct!(
      "Unit::#{m.params['type']}", m.params['prepaid'],
      {:galaxy_id => m.player.galaxy_id}, m.params['count'].to_i
    )
  end

  # Mass updates flanks and stances of player units.
  #
  # Invocation: by client
  #
  # Parameters:
  # - updates (Hash): hash of {unit_id => [flank, stance, hidden]} pairs.
  #
  # Response: None
  #
  ACTION_UPDATE = 'units|update'

  UPDATE_OPTIONS = logged_in + required(:updates => Hash)
  def self.update_scope(m)
    unit_id, updates = m.params['updates'].first
    unit = Unit.find(unit_id)
    scope.combat(unit.location)
  rescue ActiveRecord::RecordNotFound => e
    raise Dispatcher::UnresolvableScope, e.message, e.backtrace
  end
  def self.update_action(m)
    Unit.update_combat_attributes(m.player.id, m.params['updates'])
  end

  # Mass sets hidden property on given player units.
  #
  # Invocation: by client
  #
  # Parameters:
  # - planet_id (Fixnum): planet where the units should be hidden.
  # - unit_ids (Fixnum[]): array of unit ids which should be hidden.
  # - value (Boolean): should units be hidden or not.
  #
  # Response: None
  #
  ACTION_SET_HIDDEN = 'units|set_hidden'

  SET_HIDDEN_OPTIONS = logged_in + required(
    :planet_id => Fixnum, :unit_ids => Array, :value => Boolean
  )
  def self.set_hidden_scope(m); scope.planet(m.params['planet_id']); end
  def self.set_hidden_action(m)
    Unit.mass_set_hidden(
      m.player.id, m.params['planet_id'], m.params['unit_ids'],
      m.params['value']
    )
  end

  # Attacks an NPC building in player planet.
  #
  # Invocation: by client
  #
  # Params:
  # - planet_id (Fixnum): id of a planet which player owns
  # - target_id (Fixnum): id of a NPC building which player wants to attack
  # - unit_ids (Fixnum[]): ids of units that should participate in
  # the battle.
  #
  # Response:
  # - notification_id (Fixnum): ID of the notification for this player
  # that notifies about this battle.
  #
  ACTION_ATTACK = 'units|attack'

  ATTACK_OPTIONS = logged_in + required(
    :planet_id => Fixnum, :target_id => Fixnum, :unit_ids => Array
  )
  def self.attack_scope(m); scope.planet(m.params['planet_id']); end
  def self.attack_action(m)
    raise GameLogicError.new("unit_ids cannot be empty!") \
      if m.params['unit_ids'].blank?

    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['planet_id'])
    target = planet.buildings.find(m.params['target_id'])
    raise ActiveRecord::RecordNotFound.new(
      "#{m.params['target_id']} must be NPC building!"
    ) unless target.npc?

    player_units = Unit.in_location(planet.location_attrs).
      where(:player_id => m.player.id).find(m.params['unit_ids'])

    unless m.`params['unit_ids'].size == player_units.size
      missing_ids = m.params['unit_ids'] - player_units.map(&:id)
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

    respond m, :notification_id => assets.notification_ids[m.player.id]
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
  ACTION_MOVE_META = 'units|move_meta'

  MOVE_META_OPTIONS = logged_in + required(
    :unit_ids => Array, :source => Hash, :target => Hash, :avoid_npc => Boolean
  )
  # Ignores spawns in galaxy/solar system.
  def self.move_meta_scope(m); scope.player(m); end
  def self.move_meta_action(m)
    source, target = resolve_location(m)

    arrival_date, hop_count = UnitMover.move_meta(
      m.player.id, m.params['unit_ids'], source, target, m.params['avoid_npc']
    )

    respond m, :arrival_date => arrival_date, :hop_count => hop_count
  end

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
  # same as units|move_meta +
  # - speed_modifier (Float): 1 means no speed change
  #
  # Response: None
  #
  ACTION_MOVE = 'units|move'

  MOVE_OPTIONS = logged_in + required(
    :unit_ids => Array, :source => Hash, :target => Hash, :avoid_npc => Boolean,
    :speed_modifier => [Fixnum, Float]
  )
  def self.move_scope(m)
    source, target = resolve_location(m)
    scope.combat(source)
  end
  def self.move_action(m)
    source, target = resolve_location(m)

    sm = MoveSpeedModifier.new(m.params['speed_modifier'])
    sm.deduct_creds!(
      m.player, m.params['unit_ids'], source, target, m.params['avoid_npc']
    )

    UnitMover.move(
      m.player.id, m.params['unit_ids'], source, target, m.params['avoid_npc'],
      sm.to_f
    )
  end

  # Notifies client about units preparing for movement.
  #
  # If you're friendly - you will be supplied full routes and all the route
  # hops in the zone.
  #
  # If you're not - Route will only have #id, #player_id, #jumps_at and
  # #current location, see Route#as_json for more info. Additionally you will
  # only get next route hop.
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
  ACTION_MOVEMENT_PREPARE = 'units|movement_prepare'

  MOVEMENT_PREPARE_OPTIONS = logged_in + only_push + required(
    :route => Hash, :unit_ids => Array, :route_hops => Array
  )
  def self.movement_prepare_scope(m); scope.player(m.player); end
  def self.movement_prepare_action(m)
    respond m,
      :route => m.params['route'],
      :unit_ids => m.params['unit_ids'],
      :route_hops => m.params['route_hops']
  end

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
  # - jumps_at
  #
  # Response:
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - route_hops (RouteHop[]): Array of hop objects that should be visible
  # to you. If switching zones, always include hop to which you arrive in new
  # zone.
  # - jumps_at (Time | nil): When this route will jump out of this zone.
  #
  ACTION_MOVEMENT = 'units|movement'

  MOVEMENT_OPTIONS = logged_in + only_push + required(
    :units => Array, :route_hops => Array, :jumps_at => [NilClass, Time]
  )
  def self.movement_scope(m); scope.player(m); end
  def self.movement_action(m)
    resolver = StatusResolver.new(m.player)

    respond m,
      :units => m.params['units'].
        map { |unit| unit.as_json(:perspective => resolver) },
      :players => Player.minimal_from_objects(m.params['units']),
      :route_hops => m.params['route_hops'],
      :jumps_at => m.params['jumps_at']
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
  ACTION_DEPLOY = 'units|deploy'

  DEPLOY_OPTIONS = logged_in + required(
    :planet_id => Fixnum, :unit_id => Fixnum, :x => Fixnum, :y => Fixnum
  )
  def self.deploy_scope(m); scope.planet(m.params['planet_id']); end
  def self.deploy_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.friendly_ids).
      find(m.params['planet_id'])
    unit = Unit.where(:player_id => m.player.id).find(m.params['unit_id'])
    raise ActiveRecord::RecordNotFound.new(
      "#{unit} must be in #{planet} or other unit, which is in planet!"
    ) unless unit.location == planet.location_point || (
      unit.location.type == Location::UNIT &&
        unit.location.object.location == planet.location_point
    )

    unit.deploy(planet, m.params['x'], m.params['y'])
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
  ACTION_LOAD = 'units|load'

  LOAD_OPTIONS = logged_in + required(
    :unit_ids => Array, :transporter_id => Fixnum
  )
  def self.load_scope(m); transporter_scope(m); end
  def self.load_action(m)
    transporter = Unit.where(:player_id => m.player.id).
      find(m.params['transporter_id'])

    units = Unit.where(:player_id => m.player.id, :id => m.params['unit_ids'])
    raise ActiveRecord::RecordNotFound.new(
      "Cannot find all requested units, perhaps some does not belong to" +
        " player? Requested #{m.params['unit_ids'].size}, found #{units.size}."
    ) if units.size < m.params['unit_ids'].size

    transporter.load(units)
  end

  # Loads/unloads resources into transporter.
  #
  # Transporter must be in planet, solar system point or galaxy point.
  #
  # Invocation: by client
  #
  # Parameters:
  # - transporter_id (Fixnum): ID of transporter Unit.
  # - metal (Fixnum): Amount of metal to load. Pass negative to unload.
  # - energy (Fixnum): Amount of energy to load. Pass negative to unload.
  # - zetium (Fixnum): Amount of zetium to load. Pass negative to unload.
  #
  # Response:
  #
  # - kept_resources (Hash): if unloading resources to planet and it does not
  # have sufficient storage, then some resources are kept in the transporter.
  # In that case this hash stores how much resources were kept on this
  # transporter. If all resources were unloaded it will have all zeros there.
  #   - metal (Fixnum): >= 0
  #   - energy (Fixnum): >= 0
  #   - zetium (Fixnum): >= 0
  #
  # Pushes:
  # - objects|updated with transporter
  # If in planet:
  # - objects|updated with planet
  # If in SS or Galaxy point:
  # - objects|updated or objects|destroyed with wreckage
  #
  ACTION_TRANSFER_RESOURCES = 'units|transfer_resources'

  TRANSFER_RESOURCES_OPTIONS = logged_in + required(
    :transporter_id => Fixnum, :metal => Fixnum, :energy => Fixnum,
    :zetium => Fixnum
  )
  def self.transfer_resources_scope(m); transporter_scope(m); end
  def self.transfer_resources_action(m)
    # Duplicate params so we could modify them.
    params = m.params.dup

    raise GameLogicError.new(
      "You're not trying to do anything! All resources are 0!"
    ) if params['metal'] == 0 && params['energy'] == 0 && params['zetium'] == 0

    transporter = Unit.where(:player_id => m.player.id).
      find(params['transporter_id'])

    kept_resources = Resources::TYPES.each_with_object({}) do |res, hash|
      hash[res] = 0
    end

    if transporter.location.type == Location::SS_OBJECT
      planet = transporter.location.object

      # Check if we can load/unload things.
      raise GameLogicError.new(
        "Cannot load resources from planet: not planet owner!"
      ) if (
        params['metal'] > 0 || params['energy'] > 0 || params['zetium'] > 0
      ) && planet.player_id != m.player.id

      # Adjust how much we are unloading and in case we are unloading too much
      # reduce how much we're unloading to prevent resource loss.
      Resources::TYPES.each do |resource|
        planet_resource = planet.send(resource)
        planet_storage = planet.send(:"#{resource}_storage_with_modifier")
        available = (planet_storage - planet_resource).floor

        # If all requested resources do not fit into planet only unload
        # resources that fit.
        if params[resource.to_s] < 0 && -params[resource.to_s] > available
          kept_resources[resource] = -params[resource.to_s] - available
          params[resource.to_s] = -available
        end
      end
    end

    transporter.transfer_resources!(
      params['metal'], params['energy'], params['zetium']
    ) if params['metal'] != 0 || params['energy'] != 0 || params['zetium'] != 0

    respond m, :kept_resources => kept_resources
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
  ACTION_UNLOAD = 'units|unload'

  UNLOAD_OPTIONS = logged_in +
    required(:unit_ids => Array, :transporter_id => Fixnum)
  def self.unload_scope(m); transporter_scope(m); end
  def self.unload_action(m)
    transporter = Unit.where(:player_id => m.player.id).
      find(m.params['transporter_id'])
    raise GameLogicError.new(
      "To unload #{transporter} must be in planet, but was it #{
        transporter.location_point}!"
    ) unless transporter.location.type == Location::SS_OBJECT

    location = transporter.location.object
    units = transporter.units.find(m.params['unit_ids'])
    transporter.unload(units, location)
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
  ACTION_SHOW = 'units|show'

  SHOW_OPTIONS = logged_in + required(:unit_id => Fixnum)
  def self.show_scope(m)
    transporter = Unit.find(m.params['unit_id'])
    scope.player(transporter.player_id)
  rescue ActiveRecord::RecordNotFound => e
    raise Dispatcher::UnresolvableScope, e.message, e.backtrace
  end
  def self.show_action(m)
    transporter = Unit.where(:player_id => m.player.id).
      find(m.params['unit_id'])

    respond m, :units => transporter.units.map(&:as_json)
  end

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
  ACTION_HEAL = 'units|heal'

  HEAL_OPTIONS = logged_in +
    required(:building_id => Fixnum, :unit_ids => Array)
  def self.heal_scope(m)
    building = Building.find(m.params['building_id'])
    # Heals units which might go into combat, so everybody in the planet is
    # involved.
    scope.planet(building.planet_id)
  rescue ActiveRecord::RecordNotFound => e
    raise Dispatcher::UnresolvableScope, e.message, e.backtrace
  end
  def self.heal_action(m)
    building = Building::HealingCenter.find(m.params['building_id'])
    raise GameLogicError.new("Planet must belong to #{m.player}!") unless \
      building.planet.player_id == m.player.id

    units = Unit.find(m.params['unit_ids'])
    raise GameLogicError.new(
      "Cannot find all requested units! Requested: #{m.params['unit_ids'].size
        }, found: #{units.size}"
    ) if units.size != m.params['unit_ids'].size

    building.heal!(units)
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
  ACTION_DISMISS = 'units|dismiss'

  DISMISS_OPTIONS = logged_in +
    required(:planet_id => Fixnum, :unit_ids => Array)
  def self.dismiss_scope(m); scope.planet(m.params['planet_id']); end
  def self.dismiss_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['planet_id'])
    
    Unit.dismiss_units(planet, m.params['unit_ids'])
  end

  # Returns non moving not loaded friendly unit positions grouped by counts.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response:
  # - positions (Unit#positions): unit positions for friendly units.
  # - players (Player#minimal_from_objects): minimal players hash
  #
  ACTION_POSITIONS = 'unit|positions'

  POSITIONS_OPTIONS = logged_in
  def self.positions_scope(m); scope.friendly_to_player(m.player); end
  def self.positions_action(m)
    positions = Unit.positions(
      Unit.where(
        "location_type != ? AND route_id IS NULL AND level > 0",
        Location::UNIT
      ).where(:player_id => m.player.friendly_ids)
    )
    players = Player.minimal_from_objects(positions) do |player_id, data|
      player_id
    end

    respond m,
      :positions => positions,
      :players => players
  end

  class << self
    private
    def transporter_scope(m)
      transporter = Unit.find(m.params['transporter_id'])
      scope.combat(transporter.location)
    rescue ActiveRecord::RecordNotFound => e
      raise Dispatcher::UnresolvableScope, e.message, e.backtrace
    end

    def resolve_location(m)
      source = Location.find_by_attrs(m.params['source'].symbolize_keys)
      target = Location.find_by_attrs(m.params['target'].symbolize_keys)
      raise GameLogicError.new(
        "Target #{target} is not visible for #{m.player}!"
      ) unless Location.visible?(m.player, target)

      [source, target]
    end
  end
end