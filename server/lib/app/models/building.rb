class Building < ActiveRecord::Base
  class BuildingInactiveError < GameLogicError; end

  STATE_INACTIVE = 0
  STATE_ACTIVE = 1
  STATE_WORKING = 2
  STATE_REPAIRING = 3

  belongs_to :planet, :class_name => "SsObject::Planet"
  delegate :player, :player_id, :to => :planet
  has_many :units,
    :finder_sql => proc { %Q{SELECT * FROM `#{Unit.table_name}` WHERE
    `location_type`=#{Location::BUILDING} AND `location_id`=#{id}} }

  include Trait
  include Location
  include Parts::WithProperties
  include Parts::BuildingValidations
  include Parts::UpgradableWithHp
  include Parts::NeedsTechnology
  include Parts::ResourceManager
  include Parts::PopulationManager
  include Parts::Constructor
  include Parts::Constructable
  include Parts::EconomyPoints
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

  # Cannot use where() here because DB connection is not established yet
  # when we are loading this.
  scope :inactive, {:conditions => {:state => STATE_INACTIVE}}
  scope :active, {:conditions => {:state => STATE_ACTIVE}}
  scope :working, {:conditions => {:state => STATE_WORKING}}
  scope :repairing, {:conditions => {:state => STATE_REPAIRING}}

  scope :of_player, Proc.new { |player|
    player = player.id if player.is_a? Player

    {
      :conditions => ["`#{SsObject.table_name}`.player_id=?", player],
      :include => :planet
    }
  }

  scope :in_solar_system, Proc.new { |solar_system|
    solar_system = solar_system.id if solar_system.is_a? SolarSystem

    where(:planet => {:solar_system_id => solar_system})
  }

  # This needs to be Proc because we can't test it otherwise.
  scope :combat, Proc.new { where(:type => combat_types) }
  scope :defensive, Proc.new { where(:type => defensive_types) }

  # Regexp used to match building guns in config.
  GUNS_REGEXP = /^buildings\.(.+?)\.guns$/

  # Return Array of String building types that have guns.
  def self.combat_types
    types = []
    CONFIG.each_matching(GUNS_REGEXP) do |key, value|
      types.push key.match(GUNS_REGEXP)[1].camelcase unless value.blank?
    end
    types
  end

  def self.defensive_types
    combat_types + [Building::DefensivePortal.to_s.demodulize]
  end

  # #flags is currently tiny int, so it can store 8 flags.
  include FlagShihTzu
  has_flags(
    1 => :overdriven,
    2 => :without_points,
    # For constructors - build units in 2nd flank.
    3 => :build_in_2nd_flank,
    :check_for_column => false
  )

  def to_s
    ("<Building::%s(%s) hp:%d/%d (%3.2f%%), x: %s, y: %s, x_end: %s, " +
    "y_end: %s, lvl: %d, planet_id: %s>") % [
      type, id.to_s, hp, hit_points, hp_percentage * 100, x.to_s, y.to_s,
      x_end.to_s, y_end.to_s, level, planet_id.to_s
    ]
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
    hash = attributes.except('pause_remainder', 'hp_percentage')
    hash['hp'] = hp
    hash['overdriven'] = overdriven
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
  #
  # noinspection RubyUnusedLocalVariable
  def xp=(value); end
  # Buildings don't accumulate XP. This method always returns 0.
  def can_upgrade_by; 0; end

  # Check for combat after upgrading.
  def on_upgrade_just_finished_after_save
    super if defined?(super)
    Combat::LocationChecker.check_location(planet.location_point) if can_fight?
  end

  # Deactivate building before destruction.
  before_destroy do
    deactivate if active? && ! npc?
    true
  end

  def deactivate
    raise GameLogicError.new("Cannot deactivate, not active for #{self}!") \
      unless active?
    forbid_unmanagable!

    self.state = STATE_INACTIVE
    @activation_state = :deactivated
  end

  # #deactivate and #save!
  def deactivate!
    deactivate
    save!
  end

  def activate
    raise GameLogicError.new("Cannot activate, not inactive for #{self}!") \
      unless inactive?
    raise GameLogicError.new(
      "Cannot activate building #{self} which is being upgraded!") \
      if upgrading?
    forbid_unmanagable!

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

  # Return how much resources will player gain when he destroys this
  # building.
  def self_destruct_resources(level=nil)
    self.class.self_destruct_resources(level || self.level)
  end

  def x_end; x ? x + width - 1 : nil; end
  def y_end; y ? y + height - 1 : nil; end

  def cancel!(*args)
    super(*args) { activate }
  end

  def upgrade
    forbid_unmanagable!
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

  # Can this building be managed?
  def managable?; self.class.managable?; end

  def self.managable?; property('managable', true); end

  # Self-destructs +Building+, returning some resources to
  # +SsObject::Planet+ pool.
  def self_destruct!(with_credits=false)
    planet = self.planet

    raise GameLogicError.new("This building is not managable!") \
      unless managable?

    raise GameLogicError.new("Cannot self-destruct upgrading buildings!") if
      upgrading?

    player = nil
    if with_credits
      raise GameLogicError.new(
        "Player cannot destroy building with creds, because not enough time " +
          "has passed for him as planet owner."
      ) \
        if Time.now - planet.owner_changed <
          Cfg.buildings_self_destruct_creds_safeguard_time

      player = self.player
      creds_needed = CONFIG['creds.building.destroy']
      raise GameLogicError.new("Player does not have enough creds! Req: #{
        creds_needed}, has: #{player.creds}") if player.creds < creds_needed
      stats = CredStats.self_destruct(self)
      player.creds -= creds_needed
    else
      raise GameLogicError.new("Cannot self-destruct this building, planet " +
          "still has cooldown: #{planet.can_destroy_building_at.to_s(:db)}") \
        unless planet.can_destroy_building?
    end

    planet.can_destroy_building_at = CONFIG.evalproperty(
      "buildings.self_destruct.cooldown").since unless with_credits
    metal, energy, zetium = self_destruct_resources
    planet.metal += metal
    planet.energy += energy
    planet.zetium += zetium

    transaction do
      if with_credits
        stats.save!
        player.save!
      end
      planet.save!
      Objective::SelfDestruct.progress(self)
      destroy!
    end

    EventBroker.fire(planet, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_PROP_CHANGE)
  end

  # Moves building to new coordinates using creds.
  def move!(x, y)
    raise GameLogicError.new("This building is not managable!") \
      unless managable?

    player = self.player
    raise ArgumentError.new("Planet #{planet
      } does not belong to any player!") if player.nil?

    creds_needed = CONFIG['creds.building.move']
    raise GameLogicError.new("Player does not have enough credits! Req: #{
      creds_needed}, has: #{player.creds}") if player.creds < creds_needed

    raise GameLogicError.new(
      "Cannot move while upgrading or working (#{self.inspect})!") \
      if upgrading? || working?

    energy_provider = self.class.manages_resources? &&
      self.class.energy_generation_rate(1) > 0 && active?
    deactivate! if energy_provider

    stats = CredStats.move(self)
    player.creds -= creds_needed
    self.armor_mod = self.energy_mod = self.construction_mod = 0
    self.x = x
    self.y = y
    ensure_position_attributes
    validate_position
    raise ActiveRecord::RecordInvalid.new(self) unless errors.blank?
    calculate_mods(true)

    transaction do
      stats.save!
      player.save!
      energy_provider ? activate! : save!
      Objective::MoveBuilding.progress(self)
    end

    EventBroker.fire(self, EventBroker::CHANGED)
  end

  def points_on_upgrade
    without_points? ? 0 : super()
  end

  def points_on_destroy
    without_points? ? 0 : super()
  end

  protected
  # Raises GameLogicError if building is unmanagable.
  def forbid_unmanagable!
    raise GameLogicError.new(
      "Actions cannot be performed on unmanagable buildings!"
    ) unless managable?
  end

  before_validation :ensure_position_attributes,
    :if => Proc.new { |r| r.new_record? }
  def ensure_position_attributes
    # -1 because if x is 2, and width is 3, building takes tiles [2, 3, 4]
    # and x_end must be, 4.
    self.x_end = x + width - 1 if x
    self.y_end = y + height - 1 if y
  end

  # Calculate mods before creation if needed
  before_create :calculate_mods
  # Calculate mods if they are not calculated
  def calculate_mods(force=false)
    # Armor mod is obtained both with level and from ground.
    if force || read_attribute(:armor_mod).nil? ||
        self.constructor_mod.nil? || self.energy_mod.nil?
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
        self.class.energy_generation_rate(1) > 0 ? energy_mod : 0
      self.constructor_mod = constructor? ? constructor_mod : 0
      # Add constructor mod to construction mod
      self.construction_mod += constructor_mod
    end
  end

  before_destroy :activation_callbacks
  after_save :activation_callbacks
  def activation_callbacks
    case @activation_state
    when :deactivated
      on_deactivation
    when :activated
      on_activation
    end

    true
  end

  # Called when building is deactivated (after save)
  def on_deactivation
    super if defined?(super)
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_DEACTIVATED)
  end

  # Called when building is activated (after save)
  def on_activation
    super if defined?(super)
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
    # Recalculate mods. If we have built this building on a regular
    # ground construction mod should not apply to subsequent upgrades of
    # this building.
    self.construction_mod = 0
    calculate_mods(true)
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

    # Returns [metal, energy, zetium] of how much resources will you get if
    # you self-destruct this +Building+.
    def self_destruct_resources(level)
      metal = energy = zetium = 0
      gain = CONFIG["buildings.self_destruct.resource_gain"].to_f / 100

      1.upto(level) do |l|
        metal += metal_cost(l)
        energy += energy_cost(l)
        zetium += zetium_cost(l)
      end

      [(metal * gain).round, (energy * gain).round, (zetium * gain).round]
    end
  end
end