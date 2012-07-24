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
  NEW_SCOPE = scope.world
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
      {}, m.params['count'].to_i
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
  UPDATE_SCOPE = scope.world
  def self.update_action(m)
    # Map JSON string keys to integer keys.
    updates = m.params['updates'].map_keys { |key, value| key.to_i }
    Unit.update_combat_attributes(m.player.id, updates)
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
  SET_HIDDEN_SCOPE = scope.world
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
  # - planet_id (Fixnum): id of a planet which player/ally owns
  # - target_id (Fixnum): id of a NPC building which player wants to attack
  # - unit_ids (Fixnum[]): ids of units that should participate in
  # the battle.
  #
  # Response:
  # - notification (Notification#as_json): notification for this player
  # that notifies about this battle.
  #
  ACTION_ATTACK = 'units|attack'

  ATTACK_OPTIONS = logged_in + required(
    :planet_id => Fixnum, :target_id => Fixnum, :unit_ids => Array
  )
  ATTACK_SCOPE = scope.world
  def self.attack_action(m)
    raise GameLogicError.new("unit_ids cannot be empty!") \
      if m.params['unit_ids'].blank?

    planet = SsObject::Planet.where(player_id: m.player.friendly_ids).
      find(m.params['planet_id'])
    target = planet.buildings.find(m.params['target_id'])
    raise ActiveRecord::RecordNotFound.new(
      "#{m.params['target_id']} must be NPC building!"
    ) unless target.npc?

    player_units = Unit.in_location(planet.location_attrs).
      where(:player_id => m.player.id).find(m.params['unit_ids'])

    unless m.params['unit_ids'].size == player_units.size
      missing_ids = m.params['unit_ids'] - player_units.map(&:id)
      raise ActiveRecord::RecordNotFound.new(
        "Cannot find all units (missing ids: #{missing_ids.join(",")
          } in planet #{planet}!"
      )
    end

    assets = Combat.run_npc!(planet, m.player, player_units, target)

    # Destroy NPC building if there are no more units there.
    if target.units.blank?
      Objective::DestroyNpcBuilding.progress(target, m.player)
      target.destroy!
    end

    notification_id = assets.notification_ids[m.player.id]
    notification = Notification.find(notification_id)
    respond m, :notification => notification.as_json
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
  MOVE_META_SCOPE = scope.world
  def self.move_meta_action(m)
    without_locking do
      source, target = resolve_location(m)

      arrival_date, hop_count = UnitMover.move_meta(
        m.player.id, m.params['unit_ids'], source, target, m.params['avoid_npc']
      )

      respond m, :arrival_date => arrival_date, :hop_count => hop_count
    end
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
  MOVE_SCOPE = scope.world
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
  MOVEMENT_PREPARE_SCOPE = scope.world
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
  MOVEMENT_SCOPE = scope.world
  def self.movement_action(m)
    without_locking do
      resolver = StatusResolver.new(m.player)

      respond m,
        :units => m.params['units'].
          map { |unit| unit.as_json(:perspective => resolver) },
        :players => Player.minimal_from_objects(m.params['units']),
        :route_hops => m.params['route_hops'],
        :jumps_at => m.params['jumps_at']
    end
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
  DEPLOY_SCOPE = scope.world
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

  # Loads selected units to transporters. Loaded units and transporters must be
  # in same location.
  #
  # To use multiple transporters player must be a VIP.
  #
  # Invocation: by client
  #
  # Parameters:
  # - unit_ids (Hash): Hash of {transporter_id => [loaded_unit_ids, ...], ...}
  #
  # Response: None
  #
  # Pushes:
  # - objects|updated with transporters
  # - objects|updated (reason 'loaded') with units that were loaded into
  # transporter.
  #
  ACTION_LOAD = 'units|load'

  LOAD_OPTIONS = logged_in + required(unit_ids: Hash)
  #required(unit_ids: HashType(AllKeys(String) => ArrayType(Fixnum)))
  LOAD_SCOPE = scope.world
  def self.load_action(m)
    unit_ids = m.params['unit_ids'].map_keys { |k, v| k.to_i }

    check_transport_vip!(m.player, unit_ids)
    transporters = get_transporters(m.player.id, unit_ids)

    all_unit_ids = m.params['unit_ids'].values.flatten
    units = Unit.where(player_id: m.player.id, id: all_unit_ids).all
    raise ActiveRecord::RecordNotFound.new(
      "Cannot find all requested units, perhaps some does not belong to" +
        " player? Requested #{all_unit_ids.size}, found #{units.size}."
    ) if units.size < all_unit_ids.size
    hashed_units = units.hash_by(&:id)

    transporters.each do |transporter|
      units = unit_ids[transporter.id].map { |unit_id| hashed_units[unit_id] }
      transporter.load(units)
    end
  end

  # Unloads selected units to +SsObject+. Transporters must be in
  # +SsObject::Planet+ to perform this action.
  #
  # Invocation: by client
  #
  # Parameters:
  # - unit_ids (Hash): Hash of {transporter_id => [unloaded_unit_ids, ...], ...}
  #
  # Response: None
  #
  # Pushes:
  # - objects|updated with transporter
  # - objects|updated (reason 'unloaded') with units that were unloaded from
  # transporter.
  #
  ACTION_UNLOAD = 'units|unload'

  UNLOAD_OPTIONS = logged_in + required(unit_ids: Hash)
  #required(unit_ids: HashType(AllKeys(String) => ArrayType(Fixnum)))
  UNLOAD_SCOPE = scope.world
  def self.unload_action(m)
    unit_ids = m.params['unit_ids'].map_keys { |k, v| k.to_i }

    check_transport_vip!(m.player, unit_ids)
    transporters = get_transporters(m.player.id, unit_ids)
    transporters.each do |transporter|
      raise GameLogicError.new(
        "To unload #{transporter} must be in planet, but was it #{
          transporter.location_point}!"
      ) unless transporter.location.type == Location::SS_OBJECT

      location = transporter.location.object
      units = transporter.units.find(unit_ids[transporter.id])
      transporter.unload(units, location)
    end
  end

  # Loads/unloads resources into transporters.
  #
  # Transporters must be in planet, solar system point or galaxy point. All
  # transporters must be in same location point.
  #
  # !!!
  # !!! When using multi load/unload be sure to provide same signs for each
  # !!! resource, i.e. either all transporters must load or unload metal for
  # !!! instance. Otherwise kept_resources will be nonsense.
  # !!!
  #
  # Invocation: by client
  #
  # Parameters:
  # - transporters (Hash): Hash of {
  #   transporter_id (String) => {
  #     'metal' => Fixnum, 'energy' => Fixnum, 'zetium' => Fixnum
  #   },
  #   ...
  # }
  # * transporter_id (Fixnum): ID of transporter Unit.
  # * metal (Fixnum): Amount of metal to load. Pass negative to unload.
  # * energy (Fixnum): Amount of energy to load. Pass negative to unload.
  # * zetium (Fixnum): Amount of zetium to load. Pass negative to unload.
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
  # - objects|updated with transporters
  # If in planet:
  # - objects|updated with planet
  # If in SS or Galaxy point:
  # - objects|updated or objects|destroyed with wreckage
  #
  ACTION_TRANSFER_RESOURCES = 'units|transfer_resources'

  TRANSFER_RESOURCES_OPTIONS = logged_in + required(
    transporters: Hash
    #transporters: HashType(AllKeys(String) => HashType(
    #  'metal' => Fixnum, 'energy' => Fixnum, 'zetium' => Fixnum
    #))
  )
  TRANSFER_RESOURCES_SCOPE = scope.world
  def self.transfer_resources_action(m)
    # Duplicate params so we could modify them.
    params = m.params.dup

    transporter_data = m.params['transporters'].map_keys { |k, v| k.to_i }
    check_transport_vip!(m.player, transporter_data)

    raise GameLogicError.new(
      "You're not trying to do anything! All resources for all transporters " +
      "are 0!"
    ) if transporter_data.all? do |transporter_id, data|
      data['metal'] == 0 && data['energy'] == 0 && data['zetium'] == 0
    end

    transporters = get_transporters(m.player.id, transporter_data)

    kept_resources = Resources::TYPES.each_with_object({}) do |res, hash|
      hash[res] = 0
    end

    # Find planet if needed. All transporters must be in same location.
    if transporters.first.location.type == Location::SS_OBJECT
      planet = transporters.first.location.object
      # Calculate how much resources can this planet store.
      planet_available = Resources::TYPES.each_with_object({}) do
        |resource, available|

        planet_resource = planet.send(resource)
        planet_storage = planet.send(:"#{resource}_storage_with_modifier")
        available[resource] = (planet_storage - planet_resource).floor
      end
    end

    transporters.each do |transporter|
      data = transporter_data[transporter.id]
      if planet
        # Check if we can load/unload things.
        raise GameLogicError.new(
          "Cannot load resources from #{planet}: not planet owner && planet " +
          "not NPC!"
        ) if (
          data['metal'] > 0 || data['energy'] > 0 || data['zetium'] > 0
        ) && ! (planet.player_id == m.player.id || planet.player_id.nil?)

        # Adjust how much we are unloading and in case we are unloading too much
        # reduce how much we're unloading to prevent resource loss.
        Resources::TYPES.each do |resource|
          available = planet_available[resource]
          value = data[resource.to_s]
          # If all requested resources do not fit into planet only unload
          # resources that fit.
          if value < 0
            unloading = -value
            if unloading > available
              # Unloading more than we can.
              kept_resources[resource] += unloading - available
              data[resource.to_s] = -available
              planet_available[resource] = 0
            else
              # Unloading less, need to reduce available planet storage.
              planet_available[resource] -= unloading
            end
          end
        end
      end

      transporter.transfer_resources!(
        data['metal'], data['energy'], data['zetium']
      ) if data['metal'] != 0 || data['energy'] != 0 || data['zetium'] != 0
    end

    respond m, kept_resources: kept_resources
  end

  # Shows units contained in other unit.
  #
  # Invoked: by client
  #
  # Parameters:
  # - unit_ids (Fixnum[])
  #
  # Response:
  # - units (Unit[]): Units contained in those units.
  #
  ACTION_SHOW = 'units|show'

  SHOW_OPTIONS = logged_in + required(:unit_ids => Array)
  SHOW_SCOPE = scope.world
  def self.show_action(m)
    without_locking do
      raise GameLogicError,
        "Cannot show multiple transporters if you're not VIP." \
        unless m.player.vip? || m.params['unit_ids'].size <= 1

      transporters = Unit.where(player_id: m.player.id).
        find(m.params['unit_ids'])

      respond m, units: transporters.map(&:units).flat_map(&:as_json)
    end
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
  HEAL_SCOPE = scope.world
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
  DISMISS_SCOPE = scope.world
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
  POSITIONS_SCOPE = scope.world
  def self.positions_action(m)
    without_locking do
      positions = Unit.positions(
        Unit.where(
          "location_unit_id IS NULL AND route_id IS NULL AND level > 0"
        ).where(:player_id => m.player.friendly_ids)
      )
      players = Player.minimal_from_objects(positions) do |player_id, data|
        player_id
      end

      respond m,
        :positions => positions,
        :players => players
    end
  end

  class << self
    private
    def resolve_location(m)
      source = Location.find_by_type_hash(m.params['source'].symbolize_keys)
      target = Location.find_by_type_hash(m.params['target'].symbolize_keys)
      raise GameLogicError.new(
        "Target #{target} is not visible for #{m.player}!"
      ) unless Location.visible?(m.player, target)

      [source, target]
    end

    def check_transport_vip!(player, unit_ids)
      raise GameLogicError,
        "Cannot load/unload into/from multiple transporters if #{player
        } is not VIP!" unless player.vip? || unit_ids.size <= 1
    end

    def get_transporters(player_id, unit_ids)
      transporter_ids = unit_ids.keys

      raise GameLogicError.new(
        "You must use at least one transporter!"
      ) if transporter_ids.blank?

      transporters = Unit.where(player_id: player_id).find(transporter_ids)
      raise ActiveRecord::RecordNotFound.new(
        "Cannot find all requested transporters, perhaps some does not " +
        "belong to player? Requested #{transporter_ids.size}, found #{
        transporters.size}."
      ) if transporters.size < transporter_ids.size

      location = transporters.first.location
      raise GameLogicError.new(
        "All transporters should be in same location!"
      ) if transporters.any? { |t| t.location != location }

      transporters
    end
  end
end