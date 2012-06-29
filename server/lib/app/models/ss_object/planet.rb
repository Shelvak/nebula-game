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
      "height" => height,
      "spawn_counter" => spawn_counter,
      "next_spawn" => next_spawn
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
        additional["viewable"] =
          ! (observer_player_ids & resolver.friendly_ids).blank?
      end
    end
    
    super(options).merge(additional)
  end
  
  def client_location
    location_point.client_location
  end

  def landable?; true; end

  # Returns player ids which can look into this planet. Does not include nil
  # player id.
  def observer_player_ids
    player_ids = Unit.player_ids_in_location(self).compact
    player_ids |= [player_id] unless player_id.nil?
    Player.join_alliance_ids(player_ids)
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

    unrepairable = buildings.reject { |b| b.is_a?(Parts::Repairable) }
    raise GameLogicError,
      "All buildings must be repairable, but unrepairable buildings #{
        unrepairable.map { |b| "<#{b.type} #{b.id}>" } } were given!" \
        unless unrepairable.blank?

    not_here = buildings.reject { |b| b.planet_id == id }
    raise GameLogicError,
      "All buildings must be in #{self}, but buildings #{
        not_here.map { |b| "<#{b.type} #{b.id} planet id: #{b.planet_id}>" }
      } were not in it!" unless not_here.blank?

    technology = Technology::BuildingRepair.get!(player_id)

    damaged_hp = buildings.inject(0) do |hp, building|
      building.mass_repair(self, technology)
      CallbackManager.register(
        building, CallbackManager::EVENT_COOLDOWN_EXPIRED,
        building.cooldown_ends_at
      )
      hp + building.damaged_hp
    end

    BulkSql::Building.save(buildings)
    save!

    EventBroker.fire(buildings, EventBroker::CHANGED)
    EventBroker.fire(
      self, EventBroker::CHANGED, EventBroker::REASON_OWNER_PROP_CHANGE
    )
    Objective::RepairHp.progress(player, damaged_hp)
  end

  def spawn_boss!
    raise GameLogicError, "Planet must be in a battleground!" \
      unless solar_system.battleground?

    cooldown = self.cooldown
    raise GameLogicError,
      "Cannot spawn while planet has a cooldown! (until #{cooldown})" \
      unless cooldown.nil?

    raise GameLogicError,
      "You cannot spawn until #next_spawn expires at #{next_spawn}" \
      if next_spawn.present? && next_spawn > Time.now

    units = UnitBuilder.from_random_ranges(
      Cfg.planet_boss_spawn_definition(solar_system),
      location_point, nil, spawn_counter, 1
    )
    Unit.save_all_units(units, nil, EventBroker::CREATED)

    self.spawn_counter += 1
    self.next_spawn = Cfg.planet_boss_spawn_random_delay_date(solar_system)
    self.save!

    EventBroker.fire(self, EventBroker::CHANGED)
    Combat::LocationChecker.check_location(location_point)
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
    OwnerChangeHandler.new(self, old_player, new_player).handle!
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
        TechTracker::METAL_GENERATE, TechTracker::METAL_STORE,
        TechTracker::ENERGY_GENERATE, TechTracker::ENERGY_STORE,
        TechTracker::ZETIUM_GENERATE, TechTracker::ZETIUM_STORE
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
end