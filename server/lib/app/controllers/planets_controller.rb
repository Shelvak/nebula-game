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
  SHOW_SCOPE = scope.world
  def self.show_action(m)
    without_locking do
      planet = SsObject::Planet.find(m.params['id'])
      current_ss_id = current_ss_id(m)

      atomic! do
        set_current_ss_id(m, nil) if current_ss_id != planet.solar_system_id
        set_current_planet_ss_id(m, planet.solar_system_id)
        set_current_planet_id(m, planet.id)
      end

      if planet.observer_player_ids.include?(m.player.id)
        resolver = StatusResolver.new(m.player)

        respond m, {
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
          :units => planet.units.map { |unit|
            unit.as_json(:perspective => resolver)
          },
          :players => Player.minimal_from_objects(planet.units),
          :cooldown_ends_at => Cooldown.for_planet(planet).as_json
        }
      else
        raise GameLogicError, "Player #{m.player} cannot view this #{planet}!"
      end
    end
  end

  # Unsets currently viewed planet and planets solar system IDs.
  #
  # Invocation: by server
  #
  # Parameters: None
  #
  # Response: Fake, to increase seq number.
  #
  ACTION_UNSET_CURRENT = 'planets|unset_current'

  UNSET_CURRENT_OPTIONS = logged_in + only_push
  UNSET_CURRENT_SCOPE = scope.world
  def self.unset_current_action(m)
    atomic! do
      set_current_planet_ss_id(m, nil)
      set_current_planet_id(m, nil)
    end

    respond m, success: true
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
  PLAYER_INDEX_SCOPE = scope.world
  def self.player_index_action(m)
    without_locking do
      planets = SsObject::Planet.for_player(m.player)
      respond m,
        :planets => planets.map { |planet|
          planet.as_json(:index => true, :view => true)
        }
    end
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
  EXPLORE_SCOPE = scope.world
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
  FINISH_EXPLORATION_SCOPE = scope.world
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
  REMOVE_FOLIAGE_SCOPE = scope.world
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
  EDIT_SCOPE = scope.world
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
  BOOST_SCOPE = scope.world
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
  PORTAL_UNITS_SCOPE = scope.world
  def self.portal_units_action(m)
    without_locking do
      planet = SsObject::Planet.where(:player_id => m.player.id).
        find(m.params['id'])

      respond m,
        :unit_counts =>
          Building::DefensivePortal.portal_unit_counts_for(planet),
        :teleport_volume =>
          Building::DefensivePortal.teleported_volume_for(planet)
    end
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
  TAKE_SCOPE = scope.world
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
    
    planet.player = m.player
    planet.save!
  end

  # Spawn NPC planet boss into battleground/pulsar planet. You must have at
  # least one ground unit, the planet must be owned by NPC or you and there
  # cannot be any enemy/nap units there. Cooldown can be present, it will be
  # updated if combat ends up in a tie.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): ID of the planet you want to spawn to
  #
  # Response: None
  #
  ACTION_BG_SPAWN = 'planets|bg_spawn'

  BG_SPAWN_OPTIONS = logged_in + required(:id => Fixnum)
  BG_SPAWN_SCOPE = scope.world
  def self.bg_spawn_action(m)
    planet = get_planet(m.params['id'], m.player.friendly_ids)

    raise GameLogicError.new(
      "You must have combat ground units in planet to spawn its boss"
    ) unless without_locking {
      Unit.where(location_ss_object_id: m.params['id']).
        where(player_id: m.player.id).combat.any?(&:ground?)
    }

    check_for_enemy_or_nap_units!(m.params['id'], m.player.friendly_ids)

    Notification.create_for_ally_planet_boss_spawn(planet, m.player) \
      if planet.player_id != m.player.id && ! planet.player_id.nil?

    planet.spawn_boss!
  end

  # Reinitiate combat in planet.
  #
  # If a cooldown exists in a planet you can ignore its effects and start
  # another combat. This only applies if only forces in planet are you, your
  # allies and NPCs.
  #
  # There must be at least one NPC to reinitiate combat.
  #
  # Invocation: by player
  #
  # Parameters:
  # - id (Fixnum): planet ID.
  #
  # Response: None
  #
  ACTION_REINITIATE_COMBAT = 'planets|reinitiate_combat'

  REINITIATE_COMBAT_OPTIONS = logged_in + required(:id => Fixnum)
  REINITIATE_COMBAT_SCOPE = scope.world
  def self.reinitiate_combat_action(m)
    planet = get_planet(m.params['id'], m.player.friendly_ids)

    raise GameLogicError.new(
      "There must be at least one combat NPC unit in the planet"
    ) unless without_locking {
      Unit.where(location_ss_object_id: planet.id, player_id: nil).combat.
        exists?
    }

    raise GameLogicError.new(
      "You must have combat units in planet or planet must belong to you"
    ) unless planet.player_id == m.player.id || without_locking {
      Unit.where(location_ss_object_id: m.params['id']).
        where(player_id: m.player.id).combat.exists?
    }

    check_for_enemy_or_nap_units!(m.params['id'], m.player.friendly_ids)

    Notification.create_for_ally_planet_reinitiate_combat(planet, m.player) \
      if planet.player_id != m.player.id && ! planet.player_id.nil?

    Combat::LocationChecker.check_location(
      planet.location_point, check_for_cooldown: false
    )
  end

  class << self
  private
    def check_for_enemy_or_nap_units!(planet_id, friendly_ids)
      raise GameLogicError.new(
        "There cannot be any enemy/nap units in planet"
      ) if without_locking {
        Unit.where(location_ss_object_id: planet_id).where(
          "player_id NOT IN (?) AND player_id IS NOT NULL", friendly_ids
        ).exists?
      }
    end

    def get_planet(planet_id, friendly_ids)
      planet = SsObject::Planet.find(planet_id)
      raise GameLogicError,
        "Planet must be owned by friendly player or NPC" \
        unless (friendly_ids + [nil]).include?(planet.player_id)
      planet
    end
  end
end