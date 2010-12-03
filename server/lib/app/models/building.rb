class Building < ActiveRecord::Base
  class BuildingInactiveError < GameLogicError; end

  STATE_INACTIVE = 0
  STATE_ACTIVE = 1
  STATE_WORKING = 2

  belongs_to :planet, :class_name => "SsObject::Planet"
  delegate :player, :player_id, :to => :planet
  has_many :units,
    :finder_sql => %Q{SELECT * FROM `#{Unit.table_name}` WHERE
    `location_type`=#{Location::BUILDING} AND `location_id`=#\{id\}}

  include Trait
  include Location
  include Parts::WithProperties
  include Parts::BuildingValidations
  include Parts::UpgradableWithHp
  include Parts::NeedsTechnology
  include Parts::ResourceManager
  include Parts::Constructor
  include Parts::Constructable
  include Parts::BattleParticipant
  def armor_mod 
    super + (read_attribute(:armor_mod) || 0)
  end
  # Buildings are always in neutral stance.
  def stance; Combat::STANCE_NEUTRAL; end

  # Order matters here, notification control methods should be above
  # included module.

  # Constructors take care of that.
  def self.notify_on_create?; false; end
  def self.notify_on_update?; false; end
  include Parts::Notifier
  include Parts::Object

  scope :inactive, :conditions => {:state => STATE_INACTIVE}
  scope :active, :conditions => {:state => STATE_ACTIVE}
  scope :working, :conditions => {:state => STATE_WORKING}

  scope :of_player, Proc.new { |player|
    player = player.id if player.is_a? Player

    {
      :conditions => ["`#{SsObject.table_name}`.player_id=?", player],
      :include => :planet
    }
  }

  scope :in_solar_system, Proc.new { |solar_system|
    solar_system = solar_system.id if solar_system.is_a? SolarSystem

    {
      :conditions => ["`#{SsObject.table_name}`.solar_system_id=?", solar_system],
      :include => :planet
    }
  }
  
  # This needs to be Proc because we can't test it otherwise.
  scope :shooting, Proc.new {
    {:conditions => {:type => shooting_types}}
  }
  
  # Regexp used to match building guns in config.
  SHOOTING_REGEXP = /^buildings\.(.+?)\.guns$/

  # Return Array of String building types that have guns.
  def self.shooting_types
    types = []
    CONFIG.each_matching(SHOOTING_REGEXP) do |key, value|
      types.push key.match(SHOOTING_REGEXP)[1].camelcase unless value.blank?
    end
    types
  end

  def to_s
    "<Building::#{type} hp:#{hp}/#{hp_max}, x: #{x}, y: #{y
      }, x_end: #{x_end}, y_end: #{y_end
      }, lvl: #{level}, planet_id: #{planet_id}>"
  end

  # Return Array of player ids which can observe this building (see it's
  # units).
  def observer_player_ids
    if npc?
      planet = self.planet
      planet.player_id.nil? ? [] : [planet.player_id]
    else
      []
    end
  end

  def as_json(options=nil)
    hash = attributes.except('pause_remainder')
    yield hash if block_given?
    hash
  end

  # See Location#location_attrs
  def location_attrs
    {
      :location_id => id,
      :location_type => Location::BUILDING,
      :location_x => nil,
      :location_y => nil
    }
  end

  def constructor?; self.class.constructor?; end
  def active?; state == STATE_ACTIVE; end
  def inactive?; state == STATE_INACTIVE; end
  def working?; state == STATE_WORKING; end
  # Building combat properties

  # Buildings have fortified armor.
  def armor; :fortified; end
  # They do not have ability to evade.
  def evasiveness; 0; end
  # They are always on the ground.
  def kind; :ground; end
  # Buildings don't accumulate XP. This method always returns 0.
  def xp; 0; end
  # Buildings don't accumulate XP. This method doesn't change anything.
  def xp=(value); end
  # Buildings don't accumulate XP. This method always returns 0.
  def can_upgrade_by; 0; end

  def deactivate
    raise GameLogicError.new("Cannot deactivate, not active!") \
      unless active?
    forbid_npc_actions!

    self.state = STATE_INACTIVE
    @activation_state = :deactivated
  end

  # #deactivate and #save!
  def deactivate!
    deactivate
    save!
  end

  def activate
    raise GameLogicError.new("Cannot activate, not inactive!") \
      unless inactive?
    forbid_npc_actions!

    self.state = STATE_ACTIVE
    @activation_state = :activated
  end

  # #activate and #save!
  def activate!
    activate
    save!
  end

  def width; self.class.width; end
  def height; self.class.height; end

  # Retrieve how much hit points this building should have in _level_.
  #
  # Buildings at level 0 always have 0 hit points.
  #
  def hit_points(level=nil)
    self.class.hit_points(level || self.level)
  end

  def x_end; x ? x + width - 1 : nil; end
  def y_end; y ? y + height - 1 : nil; end

  %w{x x_end y y_end}.each do |attr|
    define_method("#{attr}=") do |value|
      if new_record?
        write_attribute(attr, value)
      else
        raise ArgumentError.new("#{attr} is unchangable after create!")
      end
    end
  end

  def upgrade
    forbid_npc_actions!
    super
    deactivate if active?
  end

  # Building damage is not affected in any way.
  def damage_mod; 0; end

  # Calculate mods before returning upgrade time.
  # Overrides Parts::Upgradable::InstanceMethods#upgrade_time
  def upgrade_time(for_level=nil)
    calculate_mods
    super(for_level)
  end

  protected
  # Raises GameLogicError if building is npc building.
  def forbid_npc_actions!
    raise GameLogicError.new(
      "Actions cannot be performed on NPC buildings!"
    ) if npc?
  end

  before_validation :ensure_attributes,
    :if => Proc.new { |r| r.new_record? }
  def ensure_attributes
    # -1 because if x is 2, and width is 3, building takes tiles [2, 3, 4]
    # and x_end must be, 4.
    self.x_end = x + width - 1 if x
    self.y_end = y + height - 1 if y
  end

  # Calculate mods before creation if needed
  before_create :calculate_mods
  # Calculate mods if they are not calculated
  def calculate_mods
    # Armor mod is obtained both with level and from ground.
    if read_attribute(:armor_mod).nil? or self.constructor_mod.nil? \
        or self.energy_mod.nil?
      armor_mod = 0
      constructor_mod = 0
      energy_mod = 0
      Tile.for_building(self).count(:group => "kind").each do |kind, count|
        name = Tile::MAPPING[kind]
        armor_mod += count * (CONFIG["tiles.#{name}.mod.armor"] || 0)
        constructor_mod += count * (
          CONFIG["tiles.#{name}.mod.construction"] || 0)
        energy_mod += count * (CONFIG["tiles.#{name}.mod.energy"] || 0)
      end

      self.armor_mod = armor_mod
      # Take energy generation rate at level 1 because at level 0 buildings
      # do not generate any energy.
      self.energy_mod = self.class.manages_resources? &&
        energy_generation_rate(1) > 0 ? energy_mod : 0
      self.constructor_mod = constructor? ? constructor_mod : 0
      # Add constructor mod to construction mod
      self.construction_mod += constructor_mod
    end
  end

  after_save :activation_callbacks
  def activation_callbacks
    case @activation_state
    when :deactivated
      on_deactivation
    when :activated
      on_activation
    end
  end

  # Called when building is deactivated (after save)
  def on_deactivation
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_DEACTIVATED)
  end

  # Called when building is activated (after save)
  def on_activation
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_ACTIVATED)
  end

  before_create :set_hp_attributes
  def set_hp_attributes
    self.hp ||= 0
  end

  def on_upgrade_finished
    super
    activate
  end

  after_create :remove_folliage
  def remove_folliage
    Folliage.delete_all([
        "planet_id=? AND (" +
          "(x BETWEEN ? AND ? AND y BETWEEN ? AND ?) OR " +
          "(x=? AND y=?)" +
        ")",
        planet_id,
        x, x_end, y, y_end,
        x - 1, y - 1
      ])
  end

  before_destroy :release_queue
  def release_queue
    # TODO: release upgrade queue and destroy current constructable.
    # TODO: unsubscribe from all events
  end

  class << self
    def constructor?; ! property('constructor.items').nil?; end

    def width 
      value = property('width')
      raise ArgumentError.new("Width for #{self.to_s} is nil!") if value.nil?
      value
    end
    def height
      value = property('height')
      raise ArgumentError.new("Height for #{self.to_s} is nil!") if value.nil?
      value
    end
  end
end