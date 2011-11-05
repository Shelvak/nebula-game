class PlanetsController < GenericController
  ACTION_SHOW = 'planets|show'
  # Show planet map.
  #
  # Parameters:
  # - id (Fixnum) - planet_id
  #
  # Return:
  # - planet (SsObject): planet data
  # - tiles (Array): planet tiles
  # - buildings (Building[]): planet buildings
  # - folliages (Array): list of 1x1 folliages (like flowers and trees)
  # - non_friendly_jumps_at (Hash): Hash of non-friendly
  # (NAP and enemy) Route#jumps_at in format of {Route#id => Route#jumps_at}.
  # - units (Hash[]): Unit#as_json with :perspective
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom units belong.
  # - npc_units (Unit[]): NPC units
  # - cooldown_ends_at (Time): date for cooldown for this planet or nil
  #
  def action_show
    param_options :required => {:id => Fixnum}

    planet = SsObject::Planet.find(params['id'])

    if planet.observer_player_ids.include?(player.id)
      self.current_ss_id = nil if self.current_ss_id != planet.solar_system_id
      self.current_planet_ss_id = planet.solar_system_id
      self.current_planet_id = planet.id

      resolver = StatusResolver.new(player)
      respond \
        :planet => planet.as_json(
          :owner => planet.player_id == player.id,
          :view => true,
          :perspective => player
        ),
        :tiles => Tile.fast_find_all_for_planet(planet),
        :folliages => Folliage.fast_find_all_for_planet(planet),
        :buildings => planet.buildings.map(&:as_json),
        :npc_units => (planet.can_view_npc_units?(player.id) \
          ? Unit.garrisoned_npc_in(planet) \
          : []).map(&:as_json),
        :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(
          Route.non_friendly_for_ss_object(planet.id, player.friendly_ids)
        ),
        :units => planet.units.map {
          |unit| unit.as_json(:perspective => resolver)},
        :players => Player.minimal_from_objects(planet.units),
        :cooldown_ends_at => Cooldown.for_planet(planet).as_json
    else
      raise GameLogicError.new(
        "Player #{player} cannot view this #{planet}!"
      )
    end
  end

  ACTION_UNSET_CURRENT = 'planets|unset_current'
  # Unsets currently viewed planet and planets solar system IDs.
  #
  # Invocation: by server
  #
  # Parameters: None
  #
  # Response: None
  #
  def action_unset_current
    only_push!

    self.current_planet_ss_id = nil
    self.current_planet_id = nil
  end

  ACTION_PLAYER_INDEX = 'planets|player_index'
  # Sends a list of planets player currently owns.
  #
  # Invocation: Only push
  # pushed after galaxies|select
  #
  # Parameters: none
  #
  # Response:
  # - planets (SsObject::Planet[])
  #
  def action_player_index
    only_push!
    planets = SsObject::Planet.for_player(player).
      map { |planet| planet.as_json(:index => true, :view => true) }
    respond :planets => planets
  end

  # Sends an exploration mission to explore block foliage.
  # 
  # You must have a research center to be able to explore something on a 
  # planet.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - planet_id (Fixnum)
  # - x (Fixnum): x of foliage start
  # - y (Fixnum): y of foliage end
  #
  def action_explore
    param_options :required => {:planet_id => Fixnum, :x => Fixnum,
      :y => Fixnum}

    planet = SsObject::Planet.where(:player_id => player.id).find(
      params['planet_id'])

    raise GameLogicError.new(
      "You must have at least one research center or mothership to be able
        to explore!"
    ) if Building.where(
      :planet_id => planet.id, :type => ["ResearchCenter", "Mothership"]
    ).where("level > 0").count == 0

    planet.explore!(params['x'], params['y'])
  end

  # Immediately finishes exploration mission for creds.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): ID of the planet
  # 
  # Response: None
  #
  def action_finish_exploration
    param_options(:required => {:id => Fixnum})
    
    planet = SsObject::Planet.where(:player_id => player.id).
      find(params['id'])
    planet.finish_exploration!(true)
  end
  
  # Removes explorable foliage for creds.
  #
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): ID of the planet
  # - x (Fixnum): x coordinate of the tile
  # - y (Fixnum): y coordinate of the tile
  # 
  # Response: None
  #
  def action_remove_foliage
    param_options(:required => {:id => Fixnum, :x => Fixnum, :y => Fixnum})
    
    planet = SsObject::Planet.where(:player_id => player.id).
      find(params['id'])
    planet.remove_foliage!(params['x'], params['y'])
  end
  
  # Edit planet properties.
  #
  # You can only do this if you own the planet. Also you can only do this
  # if you have Mothership or Headquarters there.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): Planet id
  # - name (String): (optional) New name of the planet
  #
  # Response: None
  #
  # Pushes: objects|updated with planet
  #
  def action_edit
    param_options :required => {:id => Fixnum}, :valid => %w{name}

    planet = SsObject::Planet.where(:player_id => player.id).find(
      params['id'])

    raise GameLogicError.new(
      "You must have Mothership or Headquarters in this planet!"
    ) if Building.where(
      :planet_id => planet.id, :type => ["Mothership", "Headquarters"]
    ).where("level > 0").count == 0

    planet.name = params['name'] if params['name']

    if planet.changed?
      EventBroker.fire(planet, EventBroker::CHANGED)
      EventBroker.fire(planet, EventBroker::CHANGED,
                       EventBroker::REASON_OWNER_PROP_CHANGE)
      planet.save!
    end
  end

  # Boosts resource rate or storage for one resource. This action costs
  # creds. You can only boost your planets.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): planet id
  # - resource (String): resource type: metal, energy or zetium
  # - attribute (String): resource attribute: rate or storage
  #
  # Response: None
  #
  def action_boost
    param_options :required => {:id => Fixnum, :resource => String,
      :attribute => String}

    planet = SsObject::Planet.where(:player_id => player.id).find(
      params['id'])
    planet.boost!(params['resource'], params['attribute'])
  end

  # Returns portal units that would come to defend this planet.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): planet id
  #
  # Response:
  # - unit_counts (Hash): Building::DefensivePortal#portal_unit_counts_for
  # - teleport_volume (Fixnum): max volume of units that can be teleported
  #
  def action_portal_units
    param_options :required => {:id => Fixnum}

    planet = SsObject::Planet.where(:player_id => player.id).
      find(params['id'])

    respond \
      :unit_counts => Building::DefensivePortal.portal_unit_counts_for(planet),
      :teleport_volume => Building::DefensivePortal.teleported_volume_for(planet)
  end
  
  # Take ownership of a free planet. To take a planet, it must belong to 
  # NPC, you should not have enemies in that planet and you or your alliance
  # should have units there.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): ID of the planet you want to take
  # 
  # Response: None
  #
  def action_take
    param_options :required => {:id => Fixnum}
    
    planet = SsObject::Planet.where("player_id IS NULL").find(params['id'])
    raise GameLogicError.new(
      "To take planet ownership you must have units in that planet!"
    ) unless Unit.in_location(planet).where(:player_id => player.id).
      limit(1).count > 0
    
    report = Combat::LocationChecker.check_for_enemies(planet.location_point)
    raise GameLogicError.new(
      "You cannot have any enemies to take planet ownership!"
    ) unless report.status == Combat::CheckReport::NO_CONFLICT
    
    planet.player = player
    planet.save!
    
    # Push planet show because player now needs garissoned units and other
    # owner-related stuff.
    push ACTION_SHOW, 'id' => planet.id if current_planet_id == planet.id
  end
end