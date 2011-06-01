class Unit < ActiveRecord::Base
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

  composed_of :location, :class_name => 'LocationPoint',
      :mapping => LocationPoint.attributes_mapping_for(:location),
      :converter => LocationPoint::CONVERTER

  belongs_to :player
  belongs_to :route

  # Attributes that are shown to owner. Says what is being transported.
  TRANSPORTATION_ATTRIBUTES = %w{stored metal energy zetium}

  def as_json(options=nil)
    additional = {:location => location.as_json}

    if options
      if options[:perspective]
        resolver = options[:perspective]
        # Player was passed.
        resolver = StatusResolver.new(resolver) if resolver.is_a?(Player)
        additional[:status] = resolver.status(player_id)

        TRANSPORTATION_ATTRIBUTES.each do |attr|
          additional[attr.to_sym] = send(attr).as_json
        end if transporter? && additional[:status] == StatusResolver::YOU
      end
    end
    
    attributes.except(
      *(
        %w{location_id location_type location_x
        location_y hp_remainder pause_remainder xp} +
        TRANSPORTATION_ATTRIBUTES
      )
    ).symbolize_keys.merge(additional).as_json
  end

  # Wraps standard #destroy in SsObject::Planet#changing_viewable.
  def destroy
    SsObject::Planet.changing_viewable(location) do
      super
    end
  end

  def to_s
    "<#{self.class.to_s} id=#{id} hp=#{hp}/#{hp_max} xp=#{xp} level=#{level
      } player_id=#{player_id}>"
  end

  # Returns floating point percentage of how much unit HP is gone.
  def damaged_percentage
    1 - alive_percentage
  end

  # Returns floating point percentage of how much unit HP is intact.
  def alive_percentage
    hp.to_f / hit_points
  end

  # Return location attributes for units that will be inside this unit.
  #
  # See Location#location_attrs
  def location_attrs
    {
      :location_id => id,
      :location_type => Location::UNIT,
      :location_x => nil,
      :location_y => nil
    }
  end

  # Returns +LocationPoint+ describing this unit
  def location_point
    UnitLocation.new(id)
  end

  def planet
    location_type == Location::SS_OBJECT ? location : nil
  end
  
  def planet_id
    location_type == Location::SS_OBJECT ? location_id : nil
  end

  def planet_id=(value)
    self.location_id = value
    self.location_type = Location::SS_OBJECT
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

      if xp >= xp_needed
        self.xp -= xp_needed
        self.level += 1
      else
        raise GameLogicError.new(
          "#{xp_needed} xp was required to upgrade, but only #{xp
            } provided!"
        )
      end
    end
  end

  # Checks how many levels we can upgrade with current xp.
  def can_upgrade_by
    if level == 0 or npc? or dead?
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
    property('population') or raise ArgumentError.new(
      "property population is nil for #{self}")
  end

  protected
  def on_upgrade_just_finished_after_save
    super
    # Sometimes unit can be built without player, e.g. when planet was
    # conquered by NPC during building time. Then we should not increase
    # visibility.
    if level == 1 && space? && ! player.nil?
      location_id = location_type == Location::SS_OBJECT \
        ? location.object.solar_system_id : location.id
      FowSsEntry.increase(location_id, player, 1)
    end
  end

  before_save :upgrade_through_xp
  def upgrade_through_xp
    number = can_upgrade_by
    if number > 0
      number.times { upgrade }
      # Notify quest event handler about upgrade.
      QUEST_EVENT_HANDLER.fire(self, EventBroker::CHANGED,
        EventBroker::REASON_UPGRADE_FINISHED)
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
    player.population += population
    player.save!
  end

  after_destroy do
    player = self.player
    if player
      player.population -= population
      player.save!
    end
  end

  class << self
    def on_callback(id, event)
      case event 
      when CallbackManager::EVENT_DESTROY
        unit = find(id)
        unit.destroy
        EventBroker.fire(unit, EventBroker::DESTROYED)
      else
        raise CallbackManager::UnknownEvent.new(self, id, event)
      end
    end
    
    def update_combat_attributes(player_id, updates)
      transaction do
        updates.each do |unit_id, attributes|
          flank, stance = attributes
          raise ArgumentError.new(
            "flank #{flank} is invalid (too large)!"
          ) unless flank_valid?(flank)
          raise ArgumentError.new(
            "stance #{stance} is invalid!"
          ) unless stance_valid?(stance)

          update_all(
            ["flank=?, stance=?", flank, stance],
            ["id=? AND player_id=?", unit_id, player_id]
          )
        end
      end
    end

    # Return distinct player ids for given +Location+.
    def player_ids_in_location(location)
      LOGGER.block "Checking for player ids in #{location}",
      :level => :debug do
        conditions = sanitize_sql_hash_for_conditions(
          location.location_attrs)

        # Do not compact here, because NPC units are also distinct player id
        # values.
        connection.select_values(
          "SELECT DISTINCT(player_id) FROM `#{Unit.table_name}` WHERE #{
            conditions}"
        ).map { |id| id.nil? ? nil : id.to_i }
      end
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
      units = {}

      connection.select_all(
        %{SELECT `type`, COUNT(*) as count
        FROM `#{table_name}`
        WHERE #{sanitize_sql_hash_for_conditions(
          location.location_attrs.merge(
            :player_id => player_id,
            :id => unit_ids
          )
        )}
        GROUP BY `type`
        }
      ).each do |row|
        units[row['type']] = row['count'].to_i
      end

      units
    end

    # Updates all units matching by _conditions_ to given +LocationPoint+.
    def update_location_all(location, conditions=nil)
      update_all(
        ["location_id=?, location_type=?, location_x=?, location_y=?",
          location.id, location.type, location.x, location.y],
        conditions
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

      player_cache = {}

      # Remove army points when losing units.
      grouped_units.each do |player_id, player_units|
        loaded_units = []
        player_units.each do |unit|
          loaded_units += unit.units if unit.stored > 0
        end

        points = (player_units + loaded_units).map(&:points_on_destroy).sum
        population = (player_units + loaded_units).map(&:population).sum
        player_cache[player_id] = Player.find(player_id)
        player_cache[player_id].population -= population
        change_player_points(
          player_cache[player_id],
          points_attribute,
          - points
        )
      end

      location = units[0].location
      SsObject::Planet.changing_viewable(location) do
        unit_ids = units.map(&:id)
        # Delete units and other units inside those units.
        delete_all(["id IN (?) OR (location_type=? AND location_id IN (?))",
            unit_ids, Location::UNIT, unit_ids])
        eb_units = killed_by.nil? ? units : CombatArray.new(units, killed_by)

        EventBroker.fire(eb_units, EventBroker::DESTROYED, reason)

        if location.type == Location::SOLAR_SYSTEM ||
            location.type == Location::SS_OBJECT
          location_id = location.type == Location::SOLAR_SYSTEM \
            ? location.id : location.object.solar_system_id

          grouped_units.each do |player_id, player_units|
            unit_count = player_units.reject { |unit| ! unit.space? }.size
            FowSsEntry.decrease(location_id, player_cache[player_id],
              unit_count) unless unit_count == 0
          end
        end

        true
      end
    end

    # Saves given units and fires _event_ for them.
    def save_all_units(units, reason=nil, event=EventBroker::CHANGED)
      return true if units.blank?

      transaction { units.each { |unit| unit.save! } }
      EventBroker.fire(units, event, reason)
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

    # Returns Unit[] of NPC units in given _planet_.
    def garrisoned_npc_in(planet)
      npc_building_ids = planet.buildings.reject do |building|
        ! building.npc?
      end.map { |building| building.id }

      if npc_building_ids.blank?
        []
      else
        where(
          :location_type => Location::BUILDING,
          :location_id => npc_building_ids
        ).all
      end
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
      points = UnitPointsCounter.new
      population = 0

      description.each do |type, count|
        klass = "Unit::#{type.camelcase}".constantize
        count.times do
          unit = klass.new(:hp => klass.hit_points(1), :level => 1,
            :player => player, :location => location,
            :galaxy_id => player.galaxy_id)
          points.add_unit(unit)
          population += unit.population
          units.push unit
        end
      end

      points.increase(player)
      player.population += population
      player.save!
      save_all_units(units, nil, EventBroker::CREATED)

      units
    end

    def dismiss_units(planet, unit_ids)
      percentage = CONFIG["units.self_destruct.resource_gain"] / 100.0
      units = where(
        :id => unit_ids,
        :player_id => planet.player_id,
        :location_type => Location::SS_OBJECT,
        :location_id => planet.id
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