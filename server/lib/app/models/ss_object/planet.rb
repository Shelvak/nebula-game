# Attributes:
#   Exploration:
#   - exploration_x (Fixnum): x of currently explored tile
#   - exploration_y (Fixnum): y of currently explored tile
#   - exploration_ends_at (Time): date/time when exploration ends
#
class SsObject::Planet < SsObject
  include Parts::PlanetExploration

  scope :for_player, Proc.new { |player|
    player_id = player.is_a?(Player) ? player.id : player

    {:conditions => {:player_id => player_id}}
  }

  # Foreign keys take care of the destruction
  has_many :tiles
  has_many :folliages
  has_many :buildings
  has_many :units,
    :finder_sql => %Q{SELECT * FROM `#{Unit.table_name}` WHERE
    `player_id` IS NOT NULL AND
    `location_type`=#{Location::SS_OBJECT} AND `location_id`=#\{id\} AND
    `location_x` IS NULL AND `location_y` IS NULL}

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
  RESOURCE_ATTRIBUTES = %w{metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        last_resources_update exploration_ends_at}

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
  # will include :status attribute in representation.
  #
  def as_json(options=nil)
    additional = {:player => Player.minimal(player_id), :name => name,
      :terrain => terrain}
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
        additional[:status] = resolver.status(player_id)
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
      [:storage, :rate].each do |type|
        name = "#{resource}_#{type}".to_sym
        send("#{name}=", send(name) + (options[name] || 0))
      end
    end
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

  private
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
    buildings.each do |building|
      if building.constructor? and building.working?
        constructable = building.constructable
        if constructable.is_a?(Unit)
          constructable.player_id = player_id
          constructable.save!
        end
      end

      if building.is_a?(Trait::Radar)
        zone = building.radar_zone
        Trait::Radar.decrease_vision(zone, old_player) if old_player
        Trait::Radar.increase_vision(zone, new_player) if new_player
      end

      if building.respond_to?(:scientists)
        scientist_count += building.scientists
      end
    end

    # Return exploring scientists if on a mission.
    stop_exploration!(old_player) if exploring?

    if scientist_count > 0
      transaction do
        old_player.change_scientist_count!(- scientist_count) if old_player
        new_player.change_scientist_count!(scientist_count) if new_player
      end
    end

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
    player_id ? Technology.find(:all, :conditions => [
      "type IN (?) AND player_id=? AND level > 0",
      self.class.modifiers,
      player_id
    ]) : []
  end

  # Get resource modifier for given _resource_.
  def resource_modifier(resource)
    (1 + resource_modifiers[resource.to_sym].to_f / 100)
  end

  # Get resource modifiers from technologies and cache them.
  def resource_modifiers(refresh=false)
    if not @resource_modifiers or refresh
      @resource_modifiers = {
        :metal => 0,
        :metal_storage => 0,
        :energy => 0,
        :energy_storage => 0,
        :zetium => 0,
        :zetium_storage => 0,
      }

      resource_modifier_technologies.each do |technology|
        technology.resource_modifiers.each do |type, modifier|
          @resource_modifiers[type] += modifier
        end
      end
    end

    @resource_modifiers
  end

  # Calculate new values.
  def recalculate
    now = Time.now
    time_diff = (now - last_resources_update).to_i
    self.last_resources_update = now
    [:metal, :energy, :zetium].each do |resource|
      value = send(resource)
      rate = send("#{resource}_rate")

      send(
        "#{resource}=",
        value + rate * time_diff * resource_modifier(resource)
      )
    end
  end

  # #recalculate and #save!
  def recalculate!
    recalculate
    save!
  end

  class << self
    def modifiers
      @modifiers ||= Set.new
    end

    def add_modifier(mod)
      modifiers.add mod
    end

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
        ) unless changes.blank?
        EventBroker.fire(model, EventBroker::CHANGED)
      else
        super
      end
    end

    # Increase rates and storages for _planet_id_.
    def increase(planet_id, options)
      model = find(planet_id)
      model.increase!(options)
      EventBroker.fire(model, EventBroker::CHANGED)
    end

    # Increases resources in the planet and fires EventBroker::CHANGED.
    def change_resources(planet_id, metal, energy, zetium)
      model = find(planet_id)
      model.metal += metal
      model.energy += energy
      model.zetium += zetium
      model.save!

      EventBroker.fire(model, EventBroker::CHANGED,
        EventBroker::REASON_RESOURCES_CHANGED)
    end
  end
end