# Attributes:
#   Exploration:
#   - exploration_x (Fixnum): x of currently explored tile
#   - exploration_y (Fixnum): y of currently explored tile
#   - exploration_ends_at (Time): datetime when exploration ends
#   Building destruction:
#   - can_destroy_building_at (Time): datetime when you can destroy next
#   building. If nil or in past, you can destroy next building.
#
class SsObject::Planet < SsObject
  include Parts::PlanetExploration
  include Parts::PlanetBoosts
  include Parts::DelayedEventDispatcher

  scope :for_player, Proc.new { |player|
    player_id = player.is_a?(Player) ? player.id : player

    {:conditions => {:player_id => player_id}}
  }

  # Planets that are being explored.
  scope :explored, :conditions => "exploration_ends_at IS NOT NULL"

  # Foreign keys take care of the destruction
  has_many :tiles
  has_many :folliages
  has_many :buildings
  has_many :market_offers
  has_many :units, :foreign_key => :location_ss_object_id

  validates_length_of :name, 
    :minimum => CONFIG['planet.validation.name.length.min'],
    :maximum => CONFIG['planet.validation.name.length.max']
  before_validation do
    self.name = name.strip.gsub(/ {2,}/, " ")
  end

  def to_s
    super + "Planet: #{name} pid:#{player_id} " +
      "m:#{metal}/#{metal_storage}@#{metal_rate} " +
      "e:#{energy}/#{energy_storage}@#{energy_rate} " +
      "z:#{zetium}/#{zetium_storage}@#{zetium_rate}" +
      ">"
  end

  def cooldown
    Cooldown.for_planet(self)
  end

  def next_raid_at=(value)
    raise ArgumentError, "#next_raid_at cannot be nil!" if value.nil?
    super(value)
  end

  # Attributes which are related to resources.
  RESOURCE_ATTRIBUTES = %w{
    metal metal_generation_rate metal_usage_rate metal_storage
    energy energy_generation_rate energy_usage_rate energy_storage
    zetium zetium_generation_rate zetium_usage_rate zetium_storage
    metal_rate_boost_ends_at metal_storage_boost_ends_at
    energy_rate_boost_ends_at energy_storage_boost_ends_at
    zetium_rate_boost_ends_at zetium_storage_boost_ends_at
    last_resources_update
  }

  # Attributes needed for planets|index
  INDEX_ATTRIBUTES = %w{next_raid_at raid_arg} + RESOURCE_ATTRIBUTES

  # Attributes which are included when :owner => true is passed to
  # #as_json
  OWNER_ATTRIBUTES = %w{
    exploration_x exploration_y exploration_ends_at 
    can_destroy_building_at
    next_raid_at raid_arg owner_changed
  } + RESOURCE_ATTRIBUTES

  # Attributes which are included when :view => true is passed to
  # #as_json
  VIEW_ATTRIBUTES = [] # No extra attributes for now.

  # Returns Planet JSON representation. It's basically same as 
  # SsObject#as_json but includes additional fields:
  # 
  # * player (Player): Planet owner (can be nil)
  # * name (String): Planet name.
  # * terrain (Fixnum): terrain variation
  # * width, height (Fixnum): width and height.
  #
  # These options can be passed:
  # * :owner => true to include owner only attributes
  # * :view => true to include properties necessary to view planet.
  # * :index => true to include properties used in planets|index.
  # * :perspective => perspective to include :status.
  #
  # _perspective_ can be either Player for which StatusResolver will be
  # initialized or an initialized StatusResolver. Using perspective option
  # will include :status and :viewable attributes in representation:
  # * :status => One of the +StatusResolver+ constants.
  # * :viewable => boolean indicating if user can click to view this planet.
  #
  def as_json(options=nil)
    additional = {
      "player" => Player.minimal(player_id),
      "name" => name,
      "terrain" => terrain,
      "width" => width,
      "height" => height
    }
    if options
      options.assert_valid_keys :owner, :view, :perspective, :index

      additional_attributes = []
      additional_attributes = additional_attributes | OWNER_ATTRIBUTES \
        if options[:owner]
      additional_attributes = additional_attributes | VIEW_ATTRIBUTES \
        if options[:view]
      additional_attributes = additional_attributes | INDEX_ATTRIBUTES \
        if options[:index]

      read_attributes(additional_attributes, additional)

      if options[:perspective]
        resolver = options[:perspective]
        # Player was passed.
        resolver = StatusResolver.new(resolver) if resolver.is_a?(Player)
        additional["status"] = resolver.status(player_id)
        additional["viewable"] = ! (
          observer_player_ids & resolver.friendly_ids).blank?
      end
    end
    
    super(options).merge(additional)
  end
  
  def client_location
    location_point.client_location
  end

  def landable?; true; end

  # Returns player ids which can look into this planet.
  def observer_player_ids
    Player.find(
      (Unit.player_ids_in_location(self) | [player_id]).compact
    ).map(&:friendly_ids).flatten.uniq
  end

  # #metal=(value)
  # #energy=(value)
  # #zetium=(value)
  #
  # Don't allow setting more than storage and less than 0.
  #
  Resources::TYPES.each do |resource|
    define_method("#{resource}=") do |value|
      storage = send("#{resource}_storage_with_modifier")

      if value > storage
        value = storage
      elsif value < 0
        value = 0
      end

      write_attribute(resource, value)
    end

    # Planet storage increased by owner technologies and other modifiers.
    define_method("#{resource}_storage_with_modifier") do
      name = "#{resource}_storage"
      read_attribute(name) * resource_modifier(name)
    end
  end

  # Valid keys for #increase.
  INCREASE_VALID_KEYS = Resources::TYPES.map do |resource|
    ["", "_storage", "_generation_rate", "_usage_rate"].map do |type|
      :"#{resource}#{type}"
    end
  end.flatten

  # Increase resource rates and storages.
  def increase(options)
    options.symbolize_keys!
    options.assert_valid_keys(INCREASE_VALID_KEYS)

    INCREASE_VALID_KEYS.each do |key|
      send("#{key}=", send(key) + (options[key] || 0))
    end
    
    # Reason is specified here because dispatcher event handler must
    # behave differently for this particular reason.
    delayed_fire(self, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_PROP_CHANGE)
  end

  # #increase and #save!
  def increase!(options)
    increase(options)
    save!
  end

  # Ensures that energy rate in the planet is >= 0.
  def ensure_positive_energy_rate!
    changes = Reducer::EnergyUsersReducer.reduce(
      # Reject buildings which do not use energy
      Building.scoped_by_planet_id(id).all.reject { |building|
        # Checking for inactive? because constructors does not use energy
        # for their operation.
        building.energy_usage_rate <= 0 or building.inactive?
      },
      - energy_rate
    )

    reload

    changes
  end

  def player_change
    old_id, new_id = player_id_change
    [
      old_id ? Player.find(old_id) : old_id,
      new_id ? Player.find(new_id) : new_id
    ]
  end

  # Checks if building can be self-destructed.
  def can_destroy_building?
    can_destroy_building_at.nil? || can_destroy_building_at < Time.now
  end
  
  RESOURCES = Resources::TYPES
  
  RESOURCES.each do |resource|
    define_method("#{resource}_rate") do
      generation_rate = send("#{resource}_generation_rate")
      usage_rate = send("#{resource}_usage_rate")
      generation_rate * resource_modifier(resource) - usage_rate
    end
  end

  # Mass-repair given buildings, reducing resources from this planet.
  def mass_repair!(buildings)
    typesig binding, Array

    unrepairable = buildings.filter { |b| b.is_a?(Parts::Repairable) }
    raise GameLogicError,
      "All buildings must be repairable, but unrepairable buildings #{
        unrepairable.map { |b| "<#{b.type} #{b.id}>" } } were given!" \
        unless unrepairable.blank?

    not_here = buildings.filter { |b| b.planet_id == id }
    raise GameLogicError,
      "All buildings must be in #{self}, but buildings #{
        not_here.map { |b| "<#{b.type} #{b.id} planet id: #{b.planet_id}>" }
      } were not in it!" unless not_here.blank?

    technology = Technology::BuildingRepair.get(player_id)

    damaged_hp = buildings.inject(0) do |hp, building|
      building.mass_repair(self, technology)
      CallbackManager.register(
        building, CallbackManager::EVENT_COOLDOWN_EXPIRED,
        building.cooldown_ends_at
      )
      hp + building.damaged_hp
    end

    BulkSql::Building.save(buildings)
    planet.save!

    EventBroker.fire(buildings, EventBroker::CHANGED)
    EventBroker.fire(
      self, EventBroker::CHANGED, EventBroker::REASON_OWNER_PROP_CHANGE
    )
    Objective::RepairHp.progress(player, damaged_hp)
  end

private

  # Set #owner_changed.
  before_update :if => Proc.new { |r| r.player_id_changed? } do
    self.owner_changed = Time.now
    
    true
  end

  # Update things if player changed.
  #
  # * Update FOW SS Entries to ensure that we see SS with our planets there
  # even if there are no radar coverage.
  # * Update constructors that are building units to make sure that the
  # units now belong to new player.
  # * Transfer scientists to new player.
  #
  # This must be done after saving this planet so all updates
  # (like planets|player_index) would have the most recent data from DB.
  after_update :if => Proc.new { |r| r.player_id_changed? } do
    old_player, new_player = player_change

    scientist_count = 0
    population_count = 0
    max_population_count = 0
    buildings.each do |building|
      if building.constructor? and building.working?
        population_count += ConstructionQueueEntry.
          where(:constructor_id => building.id).prepaid.
          map { |cqe| cqe.get_resources(cqe.count)[3] }.sum
      end

      # Inactive buildings do not give radar visibility, scientists or
      # population.
      unless building.inactive?
        if building.is_a?(Trait::Radar)
          zone = building.radar_zone
          Trait::Radar.decrease_vision(zone, old_player) if old_player
          Trait::Radar.increase_vision(zone, new_player) if new_player
        end

        scientist_count += building.scientists \
          if building.respond_to?(:scientists)

        max_population_count += building.population \
          if building.respond_to?(:population)
      end
      
      building.reset_cooldown! if building.respond_to?(:reset_cooldown!)
    end
    
    # Cancel all market offers where MarketOffer#from_kind was creds so
    # owner of the planet would retrieve his creds without fee.
    if old_player
      MarketOffer.
        where(:planet_id => id, :from_kind => MarketOffer::KIND_CREDS).
        all.each do |market_offer|
          old_player.creds += market_offer.from_amount
          market_offer.destroy!
        end
    end
    
    # Transfer any alive units that were not included in combat to new 
    # owner.
    units = Unit.in_location(self).
      where(:player_id => old_player ? old_player.id : nil)
    fse_counter_change = 1 # 1 for the planet.
    units.each do |unit|
      population_count += unit.population
      fse_counter_change += 1 if unit.space?
      unit.player = new_player
    end
    Unit.save_all_units(units)

    # Return exploring scientists if on a mission.
    stop_exploration!(old_player) if exploring?

    if scientist_count > 0
      old_player.change_scientist_count!(- scientist_count) if old_player
      new_player.change_scientist_count!(scientist_count) if new_player
    end
    
    if old_player
      old_player.population -= population_count
      old_player.population_cap -= max_population_count
    end
    if new_player
      new_player.population += population_count
      new_player.population_cap += max_population_count
    end

    # Transfer all points to new player.
    points = {}
    buildings.reject(&:npc?).each do |building|
      points_attribute = building.points_attribute
      points[points_attribute] ||= 0
      points[points_attribute] += building.points_on_destroy
    end

    unless points.blank?
      points.each do |attribute, points|
        old_player.send("#{attribute}=",
          old_player.send(attribute) - points) if old_player
        new_player.send("#{attribute}=",
          new_player.send(attribute) + points) if new_player
      end
    end
    
    solar_system = self.solar_system
    if solar_system.battleground?
      if new_player
        Unit.give_units(CONFIG['battleground.planet.bonus'], self, new_player)
      end
      old_player.bg_planets_count -= 1 if old_player
      new_player.bg_planets_count += 1 if new_player
    else
      old_player.planets_count -= 1 if old_player
      new_player.planets_count += 1 if new_player
    end

    if old_player
      paused_technologies = old_player.technologies.upgrading.all.compact_map do
        |technology|

        # We need to pass old player, because it hasn't been saved to database
        # yet.
        if technology.planets_requirement_met?(old_player)
          nil
        else
          technology.pause!
          [technology, Reducer::RELEASED]
        end
      end

      Notification.create_for_technologies_changed(
        old_player.id, paused_technologies
      ) unless paused_technologies.blank?

      old_player.save! if old_player.changed?
    end
    new_player.save! if new_player && new_player.changed?

    FowSsEntry.
      change_planet_owner(self, old_player, new_player, fse_counter_change)
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_CHANGED)

    true
  end

  before_save :update_resources_entry
  def update_resources_entry
    # Start gathering resources
    self.last_resources_update = Time.now \
      if player_id && last_resources_update.nil?
  end
  
  after_find :recalculate_if_unsynced
  def recalculate_if_unsynced
    if last_resources_update and last_resources_update.to_i < Time.now.to_i
      recalculate
    end
  end

  before_update :register_callbacks
  # Register callbacks if energy is diminishing.
  def register_callbacks
    if energy_rate < 0
      CallbackManager.register_or_update(
        self,
        CallbackManager::EVENT_ENERGY_DIMINISHED,
        last_resources_update + (energy / energy_rate).abs.ceil
      )

      self.energy_diminish_registered = true
    elsif energy_rate >= 0 and energy_diminish_registered?
      CallbackManager.unregister(self,
        CallbackManager::EVENT_ENERGY_DIMINISHED)

      self.energy_diminish_registered = false
    end

    true
  end

  def resource_modifier_technologies
    player_id ? without_locking {
      TechTracker.instance.query_active(
        player_id,
        "metal_generate", "metal_store", "energy_generate", "energy_store",
        "zetium_generate", "zetium_store"
      ).all
    } : []
  end

  # Get resource modifier for given _resource_.
  def resource_modifier(resource)
    (1 + resource_modifiers[resource.to_sym].to_f / 100)
  end

  # Get resource modifiers from technologies and cache them.
  def resource_modifiers(refresh=false)
    if not @resource_modifiers or refresh
      # Resource modifiers, Fixnums.
      @resource_modifiers = {
        :metal => 0,  :metal_storage => 0,
        :energy => 0, :energy_storage => 0,
        :zetium => 0, :zetium_storage => 0,
      }

      resource_modifier_technologies.each do |technology|
        technology.resource_modifiers.each do |type, modifier|
          @resource_modifiers[type] += modifier
        end
      end

      @resource_modifiers.keys.each do |type|
        @resource_modifiers[type] += Cfg.planet_boost_amount \
          if send(:"#{type}_boosted?")
      end
    end

    @resource_modifiers
  end

  # Calculate new values.
  def recalculate
    now = Time.now
    time_diff = (now - last_resources_update).to_i
    self.last_resources_update = now
    RESOURCES.each do |resource|
      value = send(resource)
      rate = send("#{resource}_rate")

      send("#{resource}=", value + rate * time_diff)
    end
  end

  class << self
    # Checks if any of the given _locations_ is a planet. If so it
    # calculates observer ids before and after block execution. If they are
    # changed - dispatches changed event for that planet.
    def changing_viewable(locations)
      locations = [locations] unless locations.is_a?(Array)

      # Check if any of these locations are planets.
      locations.each do |location|
        if location.type == Location::SS_OBJECT
          object = location.object
          if object.is_a?(SsObject::Planet)
            old_observers = object.observer_player_ids
            result = yield
            new_observers = object.observer_player_ids

            if old_observers != new_observers
              # If observers changed, dispatch changed on the planet.
              EventBroker.fire(object, EventBroker::CHANGED)
              # And if some players were viewing the planet, but they can't
              # anymore, dispatch event to unset their session planet ids.
              EventBroker.fire(
                Event::PlanetObserversChange.
                  new(object.id, old_observers - new_observers),
                EventBroker::CREATED
              )
            end


            # Exit the method
            return result
          end
        end
      end

      # If none of the locations were planets, just yield the block.
      yield
    end
  end
end