class Technology < ActiveRecord::Base
  include Parts::WithProperties
  include Parts::Upgradable
  include Parts::NeedsTechnology
  include Parts::SciencePoints
  include Parts::Object
  include Parts::Notifier

  def planet(reload=false)
    @_planet = nil if reload
    @_planet ||= SsObject::Planet.find(planet_id)
  end
  attr_accessor :planet_id
  belongs_to :player

  # #flags is currently tiny int, so it can store 8 flags.
  include FlagShihTzu
  has_flags(
    1 => :speed_up,
    :check_for_column => false
  )

  def as_json(options=nil)
    {
      'id' => id,
      'upgrade_ends_at' => upgrade_ends_at,
      'pause_remainder' => pause_remainder,
      'scientists' => scientists,
      'level' => level,
      'type' => type,
      'pause_scientists' => pause_scientists,
      'speed_up' => speed_up
    }
  end

  def check_upgrade!
    raise ArgumentError.new("self.planet_id is required for upgrading!") \
      unless planet_id
    raise GameLogicError.new(
      "Cannot reduce resources from planet that player doesn't own!"
    ) unless planet.player_id == player_id

    war_points = war_points_required
    raise GameLogicError.new("Player does not have enough war points! #{
      war_points} required, player has #{player.war_points}") \
      if player.war_points < war_points
    raise GameLogicError.new("Cannot upgrade technology in planet which " +
      "does not have any research centers!"
    ) unless Building::ResearchCenter.where(:planet_id => planet_id).count > 0

    super
  end

  # Check if player has enough planets for this technology.
  def check_planets!(level=nil, player=nil)
    player ||= self.player

    req_planets = planets_required(level)
    has_planets = player.planets_count
    req_pulsars = pulsars_required(level)
    has_pulsars = player.bg_planets_count

    raise GameLogicError.new(
      "Player does not have enough planets/pulsars! #{req_planets
      } planets and #{req_pulsars} pulsars are required, but player only has #{
      has_planets} planets and #{has_pulsars} pulsars!"
    ) if has_planets < req_planets || has_pulsars < req_pulsars
  end

  # Check if player has met planets requirements for this technology.
  def planets_requirement_met?(player)
    check_planets!(level, player)
    true
  rescue GameLogicError
    false
  end

  def resume
    check_planets!

    super do
      # Recalculate pause remainder if we were paused.
      self.pause_remainder = calculate_new_pause_remainder(
        self.pause_remainder, pause_scientists, scientists
      ) if pause_scientists
      self.pause_scientists = nil
    end
  end

  def upgrade_time(level=nil, scientists=nil)
    level ||= self.level
    scientists ||= self.scientists

    super(level, scientists)
  end

  # Destroys this technology. Requires creds.
  def unlearn!
    raise GameLogicError.new(
      "Cannot unlearn technology which is not finished!"
    ) unless finished?

    player = self.player
    creds_required = Cfg.technology_destroy_cost
    raise GameLogicError.new(
      "Not enough creds to destroy #{self}. Required #{creds_required}, but #{
      player} only had #{player.creds}."
    ) if player.creds < creds_required

    player.creds -= creds_required

    # #destroy! invokes player#save! too
    destroy!
    CredStats.unlearn_technology(player, creds_required)
  end

  # Overrides Parts::Upgradable::InstanceMethods#calculate_upgrade_time with
  # Technology calculation logic.
  def calculate_upgrade_time(level, scientists)
    additional_scientists = scientists - scientists_min
    time_reduction = additional_scientists > 0 \
      ? additional_scientists.to_f / scientists_min * 100 *
        CONFIG['technologies.scientists.additional'] \
      : 0
    max_time_reduction = CONFIG[
      'technologies.scientists.additional.max_reduction']
    time_reduction = max_time_reduction \
      if time_reduction > max_time_reduction

    (
      # Base upgrade time
      self.class.evalproperty('upgrade_time', nil, 'level' => level).to_f *
      # Time reduction from additional scientists
      (100 - time_reduction) / 100 /
      # Time reduction from overtime
      (speed_up ? CONFIG['technologies.speed_up.time.mod'] : 1)
    ).floor
  end

  def metal_cost(*args)
    super(*args) * (
      speed_up ? CONFIG['technologies.speed_up.resources.mod'] : 1
    )
  end

  def energy_cost(*args)
    super(*args) * (
      speed_up ? CONFIG['technologies.speed_up.resources.mod'] : 1
    )
  end

  def zetium_cost(*args)
    super(*args) * (
      speed_up ? CONFIG['technologies.speed_up.resources.mod'] : 1
    )
  end
  
  # War points required to upgrade to next level.
  def war_points_required
    self.class.war_points_required(self.level + 1)
  end
  
  # War points required to upgrade to _level_.
  def self.war_points_required(level)
    evalproperty('war_points', nil, 'level' => level).round
  end

  def planets_required(level=nil)
    self.class.planets_required(level || self.level + 1)
  end

  def self.planets_required(level)
    evalproperty('planets.required', 0, 'level' => level).round
  end

  def pulsars_required(level=nil)
    self.class.pulsars_required(level || self.level + 1)
  end

  def self.pulsars_required(level)
    evalproperty('pulsars.required', 0, 'level' => level).round
  end

  def scientists_min(level=nil)
    self.class.scientists_min(level || self.level + 1)
  end

  def self.scientists_min(level)
    evalproperty('scientists.min', nil, 'level' => level).round
  end

  # Array of [name, property] pairs for all technology mods.
  MODS = TechTracker::MODS.map do |property|
    [property.gsub(".", "_"), "mod.#{property}"]
  end
  
  MODS.each do |name, property|
    define_method("#{name}_mod") { self.class.send("#{name}_mod", level) }
    self.class.send(:define_method, "#{name}_mod") do |level|
      evalproperty(property, 0, 'level' => level)
    end

    define_method("#{name}_mod?") { self.class.send("#{name}_mod?") }
    self.class.send(:define_method, "#{name}_mod?") { !! property(property) }
    define_method("#{name}_mod_formula") {
      self.class.send("#{name}_mod_formula") }
    self.class.send(:define_method, "#{name}_mod_formula") {
      property(property).to_s }
  end

  # Returns Array of camelcased strings of class names to which this
  # technology applies.
  def applies_to
    applies_to = property('applies_to')
    raise ArgumentError.new("Property 'applies_to' was not an array (#{
      applies_to.inspect}) for #{self.class.to_s}!") \
      unless applies_to.is_a?(Array)
    applies_to.map(&:camelcase)
  end

  protected
  validate :validate_scientists
  def validate_scientists
    # `just_finished?` accounts for #on_upgrade_finished and #save
    if ! new_record? && scientists_changed? && \
        ! just_finished? \
        && (paused? || finished?)
      errors.add(:base,
        "Cannot adjust scientist count when paused or finished!"
      )
    end

    if ! @just_accelerated && (just_started? or just_resumed?)
      # Force reload of association, because DB might have changed
      player = player(true)
      errors.add(:base, "#{scientists} scientists requested but we " +
        "only have #{player.scientists}!") \
        if player.scientists < scientists
    elsif upgrading? and scientists_changed_while_upgrading?
      # Force reload of association, because DB might have changed
      player = player(true)

      old, new = scientists_change
      diff = new - old

      errors.add(:base, "Additional #{diff} scientists requested but we " +
        "only have #{player.scientists}!") \
        if player.scientists < diff
    end

    errors.add(:base, "Min #{scientists_min} scientists required, but " +
        "only #{scientists} were given!") \
        if (! scientists.nil?) && scientists < scientists_min
  end

  def on_upgrade_finished
    super
    release_scientists
  end

  def on_upgrade_just_paused_before_save
    super
    self.pause_scientists = self.scientists
    release_scientists
  end

  def on_upgrade_just_resumed_before_save
    super
    update_scientists(-scientists) unless @just_accelerated
  end

  def release_scientists
    update_scientists(scientists)
    self.scientists = nil
  end

  def update_scientists(scientists)
    player = self.player
    player.scientists += scientists
    # Don't save, #accelerate! will save that for us when updating
    # Player#creds.
    player.save! unless @just_accelerated
  end

  before_save :update_scientists_while_upgrading, :if => Proc.new { |r|
    r.upgrading? && r.scientists_changed? }
  def update_scientists_while_upgrading
    if scientists_changed_while_upgrading?
      old, new = scientists_change
      diff = new - old
      update_scientists(-diff)

      self.upgrade_ends_at = Time.now + calculate_new_pause_remainder(
        calculate_pause_remainder, old, new
      )
      CallbackManager.update(self)
    end
    true
  end

  # Recalculates new pause remainder when scientist count changes.
  def calculate_new_pause_remainder(old_pause_remainder, old_scientists,
      new_scientists)
    raise ArgumentError.new("old_pause_remainder can't be nil!") \
      if old_pause_remainder.nil?
    raise ArgumentError.new("old_scientists can't be nil!") \
      if old_scientists.nil?
    raise ArgumentError.new("new_scientists can't be nil!") \
      if new_scientists.nil?

    percentage = old_pause_remainder.to_f /
      upgrade_time(level + 1, old_scientists)

    (upgrade_time(level + 1, new_scientists) * percentage)
  end

  # Did scientists change while building was in upgrading state?
  def scientists_changed_while_upgrading?
    old, new = scientists_change
    ! (old.nil? or old == 0 or new.nil?)
  end

  def self.new_by_type(type, *args)
    "Technology::#{type.camelcase}".constantize.new(*args)
  end

  ### Callbacks ###

  def upgrade_finished_scope(technology)
    DScope.player(technology.player_id)
  end
  def upgrade_finished_callback(technology)
    technology.on_upgrade_finished!
  end
end