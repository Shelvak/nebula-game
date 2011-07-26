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
  include Parts::Shieldable
  include Parts::DelayedEventDispatcher
  include Parts::Raiding

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
  has_many :units,
    :finder_sql => proc { %Q{SELECT * FROM `#{Unit.table_name}` WHERE
    `location_type`=#{Location::SS_OBJECT} AND `location_id`=#{id} AND
    `location_x` IS NULL AND `location_y` IS NULL} }

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

  # Can given _player_id_ view resources on this planet?
  def can_view_resources?(player_id)
    self.player_id == player_id
  end

  # Can given _player_id_ view NPC units on this planet?
  #
  # Also see Building#observer_player_ids
  def can_view_npc_units?(player_id)
    self.player_id == player_id
  end

  # Attributes which are included when :resources => true is passed to 
  # #as_json
  RESOURCE_ATTRIBUTES = %w{
    metal metal_generation_rate metal_usage_rate metal_storage
    metal_rate_boost_ends_at metal_storage_boost_ends_at
    energy energy_generation_rate energy_usage_rate energy_storage
    energy_rate_boost_ends_at energy_storage_boost_ends_at
    zetium zetium_generation_rate zetium_usage_rate zetium_storage
    zetium_rate_boost_ends_at zetium_storage_boost_ends_at
    last_resources_update exploration_ends_at can_destroy_building_at
    next_raid_at}

  # Attributes which are included when :view => true is passed to
  # #as_json
  VIEW_ATTRIBUTES = %w{width height}

  # Returns Planet JSON representation. It's basically same as 
  # SsObject#as_json but includes additional fields:
  # 
  # * player (Player): Planet owner (can be nil)
  # * name (String): Planet name.
  # * terrain (Fixnum): terrain variation
  #
  # These options can be passed:
  # * :resources => true to include resources
  # * :view => true to include properties necessary to view planet.
  # * :perspective => perspective to include :status.
  #
  # _perspective_ can be either Player for which StatusResolver will be
  # initialized or an initialized StatusResolver. Using perspective option
  # will include :status and :viewable attributes in representation:
  # * :status => One of the +StatusResolver+ constants.
  # * :viewable => boolean indicating if user can click to view this planet.
  #
  def as_json(options=nil)
    additional = {"player" => Player.minimal(player_id), "name" => name,
      "terrain" => terrain}
    if options
      options.assert_valid_keys :resources, :view, :perspective
      
      read_attributes(RESOURCE_ATTRIBUTES, additional) \
        if options[:resources]

      read_attributes(VIEW_ATTRIBUTES, additional) \
        if options[:view]

      if options[:perspective]
        resolver = options[:perspective]
        # Player was passed.
        resolver = StatusResolver.new(resolver) if resolver.is_a?(Player)
        additional["status"] = resolver.status(player_id)
        additional["viewable"] = !! (
          observer_player_ids & resolver.friendly_ids).present?
      end
    end
    
    super(options).merge(additional)
  end

  def landable?; true; end

  def observer_player_ids
    (player.nil? ? [] : player.friendly_ids) |
      Unit.player_ids_in_location(self)
  end

  # #metal=(value)
  # #energy=(value)
  # #zetium=(value)
  #
  # Don't allow setting more than storage and less than 0.
  #
  %w{metal energy zetium}.each do |resource|
    define_method("#{resource}=") do |value|
      name = "#{resource}_storage"
      storage = (read_attribute(name) * resource_modifier(name))

      if value > storage
        value = storage
      elsif value < 0
        value = 0
      end

      write_attribute(resource, value)
    end
  end

  # Increase resource rates and storages.
  def increase(options)
    options.symbolize_keys!

    [:metal, :energy, :zetium].each do |resource|
      [:storage, :generation_rate, :usage_rate].each do |type|
        name = "#{resource}_#{type}".to_sym
        send("#{name}=", send(name) + (options[name] || 0))
      end
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
      Building.scoped_by_planet_id(id).all.reject do |building|
        # Checking for inactive? because constructors does not use energy
        # for their operation.
        building.energy_usage_rate <= 0 or building.inactive?
      end,
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

  # Registers raid on this planet.
  def register_raid
    self.next_raid_at = CONFIG.eval_hashrand('raiding.delay').from_now
    CallbackManager.register_or_update(self, CallbackManager::EVENT_RAID,
      self.next_raid_at)
    delayed_fire(self, EventBroker::CHANGED, 
      EventBroker::REASON_OWNER_PROP_CHANGE)
  end

  def register_raid!
    register_raid
    save!
  end

  def raid_registered?; ! next_raid_at.nil?; end

  def clear_raid
    CallbackManager.unregister(self, CallbackManager::EVENT_RAID) if \
      raid_registered?
    self.next_raid_at = nil
    delayed_fire(self, EventBroker::CHANGED, 
      EventBroker::REASON_OWNER_PROP_CHANGE)
  end

  def clear_raid!
    clear_raid
    save!
  end
  
  RESOURCES = [:metal, :energy, :zetium]
  
  RESOURCES.each do |resource|
    define_method("#{resource}_rate") do
      generation_rate = send("#{resource}_generation_rate")
      usage_rate = send("#{resource}_usage_rate")
      generation_rate * resource_modifier(resource) - usage_rate
    end
  end

  private
  # Set #next_raid_at.
  before_update :if => Proc.new { |r| r.player_id_changed? } do
    should_raid? ? register_raid : clear_raid
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
        constructable = building.constructable
        if constructable.is_a?(Unit)
          constructable.player = new_player
          population_count += constructable.population
          constructable.save!
        end

        ConstructionQueue.clear(building.id)
      end

      if building.is_a?(Trait::Radar)
        zone = building.radar_zone
        Trait::Radar.decrease_vision(zone, old_player) if old_player
        Trait::Radar.increase_vision(zone, new_player) if new_player
      end

      scientist_count += building.scientists \
        if building.respond_to?(:scientists)

      max_population_count += building.population \
        if building.respond_to?(:population)
      
      building.start_cooldown! if building.respond_to?(:start_cooldown!)
    end

    # Return exploring scientists if on a mission.
    stop_exploration!(old_player) if exploring?

    if scientist_count > 0
      transaction do
        old_player.change_scientist_count!(- scientist_count) if old_player
        new_player.change_scientist_count!(scientist_count) if new_player
      end
    end
    
    if old_player
      old_player.population -= population_count
      old_player.population_max -= max_population_count
    end
    if new_player
      new_player.population += population_count
      new_player.population_max += max_population_count
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
        new_player.victory_points += CONFIG['battleground.planet.takeover.vps']
        Unit.give_units(CONFIG['battleground.planet.bonus'], self, new_player)
      end
    else
      old_player.planets_count -= 1 if old_player
      new_player.planets_count += 1 if new_player
    end

    old_player.save! if old_player && old_player.changed?
    new_player.save! if new_player && new_player.changed?

    FowSsEntry.change_planet_owner(self, old_player, new_player)
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
  
  after_find :recalculate_if_unsynced!
  def recalculate_if_unsynced!
    if last_resources_update and last_resources_update.to_i < Time.now.to_i
      recalculate!
    end
  end

  before_update :register_callbacks
  # Register callbacks if energy is diminishing.
  def register_callbacks
    if energy_rate < 0
      method = energy_diminish_registered? ? :update : :register

      CallbackManager.send(method,
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
    player_id ? TechTracker.query_active(player_id,
      "metal_generate", "metal_store", "energy_generate", "energy_store",
      "zetium_generate", "zetium_store").all : []
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
        @resource_modifiers[type] += CONFIG['creds.planet.resources.boost'] \
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

  # #recalculate and #save!
  def recalculate!
    recalculate
    save!
  end

  class << self
    # Called back by CallbackManager.
    # 
    # When we run out of energy it runs algorithm which disables energy
    # using buildings in planet.
    #
    # When exploration is complete it rewards player and stops exploration.
    #
    def on_callback(id, event)
      case event
      when CallbackManager::EVENT_ENERGY_DIMINISHED
        model = find(id)
        changes = model.ensure_positive_energy_rate!
        Notification.create_for_buildings_deactivated(
          model, changes
        ) unless changes.blank? || model.player_id.nil?
        EventBroker.fire(model, EventBroker::CHANGED)
      when CallbackManager::EVENT_RAID
        model = find(id)
        # Don't raid if planet does not belong to planet.
        Combat.npc_raid!(model) unless model.player_id.nil?
      when CallbackManager::EVENT_EXPLORATION_COMPLETE
        find(id).finish_exploration!
      else
        raise CallbackManager::UnknownEvent.new(self, id, event)
      end
    end

    # Increases resources in the planet and fires EventBroker::CHANGED.
    def change_resources(planet_id, metal, energy, zetium)
      model = find(planet_id)
      model.metal += metal
      model.energy += energy
      model.zetium += zetium
      model.save!

      EventBroker.fire(model, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE)
    end

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

            # If observers changed, dispatch changed on the planet.
            EventBroker.fire(object, EventBroker::CHANGED) \
              if old_observers != new_observers

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