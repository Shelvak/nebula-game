class PlanetsController < GenericController
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
  # - cooldown_ends_at (Time): date for cooldown for this planet or nil
  #
  ACTION_SHOW = 'planets|show'

  SHOW_OPTIONS = logged_in + required(:id => Fixnum)
  def self.show_scope(message); scope.planet(message.params['id']); end
  def self.show_action(m)
    planet = SsObject::Planet.find(m.params['id'])

    if planet.observer_player_ids.include?(m.player.id)
      set_current_ss_id(m, nil) if current_ss_id(m) != planet.solar_system_id
      set_current_planet_ss_id(m, planet.solar_system_id)
      set_current_planet_id(m, planet.id)

      resolver = StatusResolver.new(m.player)
      respond m,
        :planet => planet.as_json(
          :owner => planet.player_id == m.player.id,
          :view => true,
          :perspective => m.player
        ),
        :tiles => Tile.fast_find_all_for_planet(planet),
        :folliages => Folliage.fast_find_all_for_planet(planet),
        :buildings => planet.buildings.map(&:as_json),
        :non_friendly_jumps_at => Route.jumps_at_hash_from_collection(
          Route.non_friendly_for_ss_object(planet.id, m.player.friendly_ids)
        ),
        :units => planet.units.map {
          |unit| unit.as_json(:perspective => resolver)},
        :players => Player.minimal_from_objects(planet.units),
        :cooldown_ends_at => Cooldown.for_planet(planet).as_json
    else
      raise GameLogicError.new("Player #{m.player} cannot view this #{planet}!")
    end
  end

  # Unsets currently viewed planet and planets solar system IDs.
  #
  # Invocation: by server
  #
  # Parameters: None
  #
  # Response: None
  #
  ACTION_UNSET_CURRENT = 'planets|unset_current'

  UNSET_CURRENT_OPTIONS = logged_in + only_push
  def self.unset_current_scope(message); scope.player(message.player); end
  def self.unset_current_action(m)
    set_current_planet_ss_id(m, nil)
    set_current_planet_id(m, nil)
  end

  # Sends a list of planets player currently owns.
  #
  # Invocation: by server
  #
  # Parameters: none
  #
  # Response:
  # - planets (SsObject::Planet[])
  #
  ACTION_PLAYER_INDEX = 'planets|player_index'

  PLAYER_INDEX_OPTIONS = logged_in + only_push
  def self.player_index_scope(message); scope.player(message.player); end
  def self.player_index_action(m)
    planets = SsObject::Planet.for_player(m.player)
    respond m,
      :planets => planets.map { |planet|
        planet.as_json(:index => true, :view => true)
      }
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
  ACTION_EXPLORE = 'planets|explore'

  EXPLORE_OPTIONS = logged_in +
    required(:planet_id => Fixnum, :x => Fixnum, :y => Fixnum)
  # This only starts exploring which is only seen by current planet owner.
  def self.explore_scope(m); scope.planet_owner(m.params['planet_id']); end
  def self.explore_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['planet_id'])

    raise GameLogicError.new(
      "You must have at least one research center to be able to explore!"
    ) unless Building::ResearchCenter.where(:planet_id => planet.id).
      where("level > 0").exists?

    planet.explore!(m.params['x'], m.params['y'])
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
  ACTION_FINISH_EXPLORATION = 'planets|finish_exploration'

  FINISH_EXPLORATION_OPTIONS = logged_in + required(:id => Fixnum)
  def self.finish_exploration_scope(m); scope.planet(m.params['id']); end
  def self.finish_exploration_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['id'])
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
  ACTION_REMOVE_FOLIAGE = 'planets|remove_foliage'

  REMOVE_FOLIAGE_OPTIONS = logged_in +
    required(:id => Fixnum, :x => Fixnum, :y => Fixnum)
  def self.remove_foliage_scope(m); scope.player(m.player); end
  def self.remove_foliage_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['id'])
    planet.remove_foliage!(m.params['x'], m.params['y'])
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
  ACTION_EDIT = 'planets|edit'

  EDIT_OPTIONS = logged_in + required(:id => Fixnum) + valid(%w{name})
  def self.edit_scope(m); scope.planet_owner(m.params['id']); end
  def self.edit_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['id'])

    raise GameLogicError.new(
      "You must have Mothership or Headquarters in this planet!"
    ) unless Building.where(
      :planet_id => planet.id, :type => ["Mothership", "Headquarters"]
    ).where("level > 0").exists?

    planet.name = m.params['name'] if m.params['name']

    if planet.changed?
      EventBroker.fire(planet, EventBroker::CHANGED)
      EventBroker.fire(
        planet, EventBroker::CHANGED, EventBroker::REASON_OWNER_PROP_CHANGE
      )
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
  ACTION_BOOST = 'planets|boost'

  BOOST_OPTIONS = logged_in +
    required(:id => Fixnum, :resource => String, :attribute => String)
  def self.boost_scope(m); scope.planet_owner(m.params['id']); end
  def self.boost_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['id'])
    planet.boost!(m.params['resource'], m.params['attribute'])
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
  ACTION_PORTAL_UNITS = 'planets|portal_units'

  PORTAL_UNITS_OPTIONS = logged_in + required(:id => Fixnum)
  def self.portal_units_scope(m); scope.friendly_to_player(m.player); end
  def self.portal_units_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['id'])

    respond m,
      :unit_counts => Building::DefensivePortal.portal_unit_counts_for(planet),
      :teleport_volume =>
        Building::DefensivePortal.teleported_volume_for(planet)
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
  ACTION_TAKE = 'planets|take'

  TAKE_OPTIONS = logged_in + required(:id => Fixnum)
  def self.take_scope(m); scope.planet(m.params['id']); end
  def self.take_action(m)
    raise GameLogicError.new("Cannot take planets during apocalypse!") \
      if m.player.galaxy.apocalypse_started?
    
    planet = SsObject::Planet.where("player_id IS NULL").find(m.params['id'])
    raise GameLogicError.new(
      "To take planet ownership you must have units in that planet!"
    ) unless Unit.in_location(planet).where("level > 0").
      where(:player_id => m.player.id).exists?
    
    report = Combat::LocationChecker.check_for_enemies(planet.location_point)
    raise GameLogicError.new(
      "You cannot have any enemies to take planet ownership!"
    ) unless report.status == Combat::CheckReport::NO_CONFLICT
    
    planet.player = player
    planet.save!
    
    # Push planet show because player now needs garrisoned units and other
    # owner-related stuff.
    push m, ACTION_SHOW, :id => planet.id if current_planet_id(m) == planet.id
  end
end