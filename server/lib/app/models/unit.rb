class Unit < ActiveRecord::Base
  DScope = Dispatcher::Scope
  include Parts::WithLocking

  include Parts::WithProperties
  include Parts::UpgradableWithHp
  include Parts::NeedsTechnology
  include Parts::BattleParticipant
  include Parts::Constructable
  include Parts::Deployable
  include Parts::Transportation
  include Parts::InLocation
  include Parts::Object
  include Parts::ArmyPoints
  include FlagShihTzu

  LOCATION_COMPOSED_OF = [
    LocationPoint::COMPOSED_OF_GALAXY,
    LocationPoint::COMPOSED_OF_SOLAR_SYSTEM,
    LocationPoint::COMPOSED_OF_SS_OBJECT,
    LocationPoint::COMPOSED_OF_BUILDING,
    LocationPoint::COMPOSED_OF_UNIT
  ]
  LOCATION_COLUMNS = (["location_x", "location_y"] + LOCATION_COMPOSED_OF.map {
    |attribute, type| "`location_#{attribute}`"
  }).join(",")

  composed_of :location, LocationPoint.composed_of_options(
    :location, *LOCATION_COMPOSED_OF
  )

  scope :combat, proc { 
    where("level > 0 AND `type` NOT IN (?) AND #{not_hidden_condition}",
          non_combat_types)
  }

  scope :non_combat, proc {
    where(
      "level > 0 AND (`type` IN (?) OR #{hidden_condition})", non_combat_types
    )
  }
  
  # Regexp used to match building guns in config.
  GUNS_REGEXP = /^units\.(.+?)\.guns$/

  # Return Array of String unit types that do not participate in combat.
  def self.non_combat_types(clear_cache=false)
    @non_combat_types = nil if clear_cache
    return @non_combat_types unless @non_combat_types.nil?

    types = []
    CONFIG.each_matching(GUNS_REGEXP) do |key, guns|
      underscore_key = key.match(GUNS_REGEXP)[1]
      # All space units participate in combat.
      kind = CONFIG["units.#{underscore_key}.kind"]
      raise "kind for unit #{underscore_key} is nil!" if kind.nil?
      is_ground = kind == :ground
      types.push underscore_key.camelcase if guns.blank? && is_ground
    end
    @non_combat_types = types
  end

  belongs_to :player
  belongs_to :route

  has_flags(
    1 => :hidden,
    :check_for_column => false
  )

  # Attributes that are shown to owner.
  OWNER_ATTRIBUTES = %w{xp}
  OWNER_TRANSPORTER_ATTRIBUTES = %w{stored metal energy zetium}

  def as_json(options=nil)
    additional = {:location => location.as_json, :hp => hp,
                  :hidden => hidden}

    if options
      if options[:perspective]
        resolver = options[:perspective]
        # Player was passed.
        resolver = StatusResolver.new(resolver) if resolver.is_a?(Player)
        additional[:status] = resolver.status(player_id)

        if additional[:status] == StatusResolver::YOU
          OWNER_ATTRIBUTES.each do |attr|
            additional[attr.to_sym] = send(attr).as_json
          end

          if transporter?
            OWNER_TRANSPORTER_ATTRIBUTES.each do |attr|
              additional[attr.to_sym] = send(attr).as_json
            end
          end
        end
      end
    end
    
    attributes.except(
      *(
        %w{location_galaxy_id location_solar_system_id location_ss_object_id
        location_building_id location_unit_id location_x location_y
        flags hp_remainder pause_remainder hp_percentage galaxy_id} +
        OWNER_ATTRIBUTES + OWNER_TRANSPORTER_ATTRIBUTES
      )
    ).symbolize_keys.merge(additional).as_json
  end

  def cancel!(*args)
    raise GameError, "#cancel! on #{self} does not make any sense!" \
      if level != 0
    super(*args) do
      EventBroker.fire(self, EventBroker::DESTROYED)
    end
  end

  # Wraps standard #destroy in Visibility#track_location_changes.
  def destroy
    Visibility.track_location_changes(location) do
      super
    end
  end

  def to_s
    "<%s id=%s hp=%d/%d (%3.2f%%) xp=%d level=%d player_id=%s>" % [
      self.class.to_s, id.to_s, hp, hit_points, hp_percentage * 100, xp, level, 
      player_id.to_s
    ]
  end

  # Return location attributes for units that will be inside this unit.
  #
  # See Location#location_attrs
  def location_attrs
    {
      :location_unit_id => id,
      :location_x => nil,
      :location_y => nil
    }
  end

  # Returns +LocationPoint+ describing this unit
  def location_point
    LocationPoint.unit(id)
  end

  def planet(reload=false)
    if location.type == Location::SS_OBJECT
      @_planet = nil if reload
      @_planet ||= SsObject::Planet.find(planet_id)
    else
      nil
    end
  end
  
  def planet_id
    location.type == Location::SS_OBJECT ? location.id : nil
  end

  def planet_id=(value)
    self.location = LocationPoint.planet(value)
  end

  def flank_valid?; self.class.flank_valid?(flank); end

  validate :validate_combat_properties
  def validate_combat_properties
    errors.add(:stance, "is invalid!") unless stance_valid?
    errors.add(:flank, "cannot be equal or more than #{
      CONFIG['combat.flanks.max']}!") unless flank_valid?
  end

  # Units are only upgraded (trained) from level 0 to level 1.
  #
  # Other level ups are not obtainable by construction, but rather by XP
  # and happen instantly, thus reducing XP and increasing level.
  #
  def upgrade
    if level == 0
      super
    else
      check_upgrade!

      xp_needed = self.xp_needed

      if xp >= xp_needed
        self.xp -= xp_needed
        self.level += 1
      else
        raise GameLogicError,
          "#{xp_needed} xp was required to upgrade from level #{level} to #{
          level + 1}, but only #{xp} provided for #{self}!"
      end
    end
  end

  # Checks how many levels we can upgrade with current xp.
  def can_upgrade_by
    if level == 0 || dead?
      0
    else
      levels = 0
      current = level
      xp_used = 0

      xp_needed = self.xp_needed(current + 1)
      while xp - xp_used >= xp_needed and current < max_level
        levels += 1
        current += 1
        xp_used += xp_needed

        xp_needed = self.xp_needed(current + 1)
      end

      levels
    end
  end
  
  def xp_needed(level=nil)
    self.class.xp_needed(level || self.level + 1)    
  end

  # Returns how much points this unit is worth. If it has units inside
  # they increase his points.
  def points_on_destroy
    points = Resources.total_volume(metal_cost, energy_cost, zetium_cost)
    points += stored - Resources.total_volume(metal, energy, zetium) \
      if stored > 0
    points
  end

  # How much population does this unit take?
  def population; self.class.population; end

  # How much population does this unit take?
  def self.population
    population = property('population')
    raise ArgumentError.new("property population is nil for #{self}") \
      if population.nil?
    population
  end

  protected
  def on_upgrade_just_finished_after_save
    super
    # If the unit was just built check its location for combat.
    Combat::LocationChecker.check_location(location) if level == 1 && can_fight?
  end

  before_save :upgrade_through_xp
  def upgrade_through_xp
    number = can_upgrade_by
    if number > 0
      number.times { upgrade }
      # Notify quest event handler about upgrade.
      QUEST_EVENT_HANDLER.fire(
        self, EventBroker::CHANGED, EventBroker::REASON_UPGRADE_FINISHED
      )
    end

    true
  end

  def validate_upgrade_resources
    super
    player = self.player
    raise GameLogicError.new("This unit does not belong to a player!") \
      if player.nil?
    needed = population
    available = player.population_max - player.population
    raise NotEnoughResources.new("Not enough population for #{player
      }, needed #{needed}, available: #{available}", self
    ) if available < needed
  end

  def on_upgrade_reduce_resources
    super
    player = self.player
    player.recalculate_population
    # Manually increase population after recalculation, because this is called
    # in before_save.
    player.population += population
    player.save!
  end

  after_destroy do
    player = self.player
    if player
      player.recalculate_population
      player.save!
    end
  end

  DESTROY_SCOPE = DScope.world
  def self.destroy_callback(unit)
    unit.destroy!
    EventBroker.fire(unit, EventBroker::DESTROYED)
  end

  UPGRADE_FINISHED_SCOPE = DScope.world
  def self.upgrade_finished_callback(unit); unit.on_upgrade_finished!; end

  class << self
    def update_combat_attributes(player_id, updates)
      unit_ids = updates.keys
      units = where(:id => unit_ids, :player_id => player_id).all

      raise GameLogicError,
        "#{unit_ids.size} units of player #{player_id} requested, but only #{
        units.size} were found. Missing ids: #{
        (unit_ids - units.map(&:id)).inspect}" if unit_ids.size != units.size

      units.each do |unit|
        flank, stance = updates[unit.id]

        raise ArgumentError.new(
          "flank #{flank} is invalid (too large)!"
        ) unless flank_valid?(flank)
        raise ArgumentError.new(
          "stance #{stance} is invalid!"
        ) unless stance_valid?(stance)

        unit.flank = flank
        unit.stance = stance
      end

      save_all_units(units)

      true
    end

    # Massively set hidden flag for player units in player planet.
    def mass_set_hidden(player_id, planet_id, unit_ids, value)
      raise GameLogicError.new(
        "Cannot set hidden flag when not in your planet!"
      ) unless SsObject::Planet.
        where(:id => planet_id, :player_id => player_id).exists?

      units = where(
        :id => unit_ids, :player_id => player_id,
        :location_ss_object_id => planet_id
      ).all
      raise GameLogicError,
        "#{unit_ids.size} units of player #{player_id} requested, but only #{
        units.size} were found. Missing ids: #{
        (unit_ids - units.map(&:id)).inspect}" if unit_ids.size != units.size

      units.each { |unit| unit.hidden = value }
      save_all_units(units)

      true
    end

    # Return distinct player ids which have completed units for given
    # +Location+.
    def player_ids_in_location(location, exclude_non_combat=false)
      LOGGER.block(
        "Checking for player ids in #{location}", :level => :debug
      ) do
        without_locking do
          # Do not compact here, because NPC units are also distinct player id
          # values.
          query = where(location.location_attrs).where("level > 0")
          query = query.combat if exclude_non_combat

          query.select("DISTINCT(player_id)").c_select_values.
            map { |id| id.nil? ? nil : id.to_i }
        end
      end
    end

    # Returns all unit positions and counts in given scope, structured in such
    # hash:
    #
    # {
    #   player_id (Fixnum) => {
    #     "#{location_id},#{location_type}" => {
    #       "location" => ClientLocation#as_json,
    #       "cached_units" => {type (String) => count (Fixnum)}
    #     },
    #     ...
    #   },
    #   ...
    # }
    #
    def positions(scope)
      without_locking do
        scope.
          select(
            "`player_id`, #{LOCATION_COLUMNS}, `type`, COUNT(*) as `count`").
          group("#{LOCATION_COLUMNS}, `type`, `player_id`").
          c_select_all
      end.inject({}) do |units, row|
        player_id = row['player_id'].to_i

        id, type = Location.id_and_type_from_row(row)

        key = "#{id},#{type},#{row['location_x']},#{row['location_y']}"

        units[player_id] ||= {}
        units[player_id][key] ||= {
          "location" => LocationPoint.new(
            id, type, row['location_x'], row['location_y']
          ).client_location.as_json,
          "cached_units" => {}
        }
        units[player_id][key]["cached_units"][row['type']] = row['count'].to_i
        units
      end
    end

    def fast_npc_fetch(scope)
      npc_units = {}
      type_cache = {}

      without_locking do
        scope.
          select(%w{
            location_x location_y
            type stance flank level
            id hp_percentage
          }).
          c_select_all.each do |row|
          type = row['type']
          location = "#{row['location_x']},#{row['location_y']}"
          second_tier =
            "#{type},#{row['stance']},#{row['flank']},#{row['level']}"

          klass = type_cache[type] ||= "Unit::#{type}".constantize
          npc_units[location] ||= {}
          npc_units[location][second_tier] ||= []
          npc_units[location][second_tier] << {
            :id => row['id'],
            :hp => (klass.hit_points * row['hp_percentage']).round,
          }
        end
      end

      npc_units
    end

    # Selects units for movement.
    #
    # Used in UnitMover#move
    #
    # Returns Hash consisting of type => count pairs.
    #
    # Types are underscored and counts are Fixnum.
    #
    def units_for_moving(unit_ids, player_id, location)
      without_locking do
        where(location.location_attrs).
          where(:player_id => player_id, :id => unit_ids).
          select("`type`, COUNT(*) as `count`").
          group("`type`").
          c_select_all
      end.each_with_object({}) do |row, units|
        units[row['type']] = row['count'].to_i
        units
      end
    end

    # Generates sql for setting location to given +LocationPoint+.
    def update_location_sql(location)
      sanitize_sql_hash_for_assignment(
        {
          :location_galaxy_id => nil, :location_solar_system_id => nil,
          :location_ss_object_id => nil, :location_unit_id => nil,
          :location_building_id => nil, :location_x => nil, :location_y => nil
        }.merge(location.location_attrs)
      )
    end

    # Deletes units. Also removes them from Route#cached_units if
    # necessary. Callbacks are not called however EventBroker is notified.
    #
    # Also deletes units inside units being deleted (transported units).
    #
    # _killed_by_ may be additional information from combat: what unit
    # was killed by what player.
    #
    # All the units must be in same location, this is not checked.
    def delete_all_units(units, killed_by=nil, reason=nil)
      return true if units.blank?
      
      units.group_by { |unit| unit.route_id }.each do
        |route_id, route_units|

        unless route_id.nil?
          Route.find(route_id).subtract_from_cached_units!(
            route_units.grouped_counts { |unit| unit.type })
        end
      end

      grouped_units = units.group_to_hash { |unit| unit.player_id }
      grouped_units.delete(nil)

      location = units[0].location
      Visibility.track_location_changes(location) do
        # Calculate army points before actual units are destroyed to still
        # get transported units.
        army_points = grouped_units.each_with_object({}) do
          |(player_id, player_units), hash|

          points = 0
          player_units.each do |unit|
            points += unit.points_on_destroy
            points += unit.units.all.sum(&:points_on_destroy) if unit.stored > 0
          end
          hash[player_id] = points
        end

        unit_ids = units.map(&:id)
        # Delete units and other units inside those units.
        where(:id => unit_ids).delete_all

        # Remove army points & recalculate population when losing units.
        # We need to recalculate population after deletion from DB.
        grouped_units.keys.each do |player_id|
          points = army_points[player_id]
          player = Player.find(player_id)
          player.recalculate_population
          change_player_points(player, points_attribute, -points)
        end

        eb_units = killed_by.nil? ? units : CombatArray.new(units, killed_by)

        EventBroker.fire(eb_units, EventBroker::DESTROYED, reason)

        true
      end
    end

    # Saves given units and fires _event_ for them.
    def save_all_units(units, reason=nil, event=EventBroker::CHANGED)
      return true if units.blank?

      units.each(&:upgrade_through_xp)
      BulkSql::Unit.save(units)
      # Don't dispatch units which are inside other units.
      updated = units.reject { |u| u.location.type == Location::UNIT }
      EventBroker.fire(updated, event, reason)
      true
    end

    # Select distinct route ids by _unit_ids_.
    def distinct_route_ids(unit_ids)
      connection.select_values(
        "SELECT DISTINCT(route_id) FROM `#{table_name}` WHERE #{
          sanitize_sql_hash_for_conditions(:id => unit_ids)}"
      ).map do |route_id|
        route_id.nil? ? nil : route_id.to_i
      end
    end

    def flank_valid?(flank)
      flank >= 0 && flank < CONFIG['combat.flanks.max']
    end

    def xp_needed(level)
      evalproperty('xp_needed', nil, 'level' => level)
    end

    # Give units described in _description_ to _player_ and place them in
    # _location_.
    #
    # Description is array of:
    # - [type, count]
    #
    # Where type is lowercased, underscored type.
    #
    def give_units(description, location, player)
      units = []

      description.each do |type, count|
        klass = "Unit::#{type.camelcase}".constantize
        count.times do
          units << klass.new(:level => 1)
        end
      end

      give_units_raw(units, location, player)
    end
    
    # Give _units_ to player.
    #
    # Units is a collection of unsaved +Unit+ objects.
    def give_units_raw(units, location, player)
      points = UnitPointsCounter.new

      units.each do |unit|
        points.add_unit(unit)
        unit.player = player
        unit.location = location
        unit.skip_validate_technologies = true
      end

      save_all_units(units, nil, EventBroker::CREATED)

      if player
        points.increase(player)
        player.recalculate_population
        player.save!

        Objective::HaveUpgradedTo.progress(units, strict: false)
      end

      # Use units[0].location because location can be planet and
      # LocationChecker expects LocationPoint.
      Combat::LocationChecker.check_location(units[0].location) \
        unless units.find(&:can_fight?).nil?

      units
    end

    def dismiss_units(planet, unit_ids)
      percentage = CONFIG["units.self_destruct.resource_gain"] / 100.0
      units = where(
        :id => unit_ids,
        :player_id => planet.player_id,
        :location_ss_object_id => planet.id,
        :upgrade_ends_at => nil
      ).all
      raise GameLogicError.new("Cannot fetch all requested units!") \
        if units.size != unit_ids.size

      metal = energy = zetium = 0
      units.each do |unit|
        metal += unit.metal_cost * unit.alive_percentage * percentage
        energy += unit.energy_cost * unit.alive_percentage * percentage
        zetium += unit.zetium_cost * unit.alive_percentage * percentage
      end
      planet.metal += metal.round
      planet.energy += energy.round
      planet.zetium += zetium.round
      planet.save!
      EventBroker.fire(planet, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE)

      delete_all_units(units)
    end
  end
end
