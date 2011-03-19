class Technology < ActiveRecord::Base
  include Parts::WithProperties
  include Parts::Upgradable
  include Parts::NeedsTechnology
  include Parts::SciencePoints

  attr_accessor :planet_id
  belongs_to :player

  def as_json(options=nil)
    attributes.except('player_id')
  end

  def planet
    SsObject.find(planet_id)
  end

  def check_upgrade!
    raise ArgumentError.new("self.planet_id is required for upgrading!") \
      unless planet_id
    raise GameLogicError.new("Cannot reduce resources from planet " +
      "that player doesn't own!") \
      unless planet.player_id == player_id
    raise GameLogicError.new("Cannot upgrade technology in planet which " +
      "does not have any research centers!"
    ) unless Building::ResearchCenter.where(
      :planet_id => planet_id).count > 0
    super
  end

  def resume
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

  # We never destroy technologies so this does not have any meaning.
  def points_on_destroy; 0; end

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

  def scientists_min(level=nil)
    self.class.scientists_min(level || self.level + 1)
  end

  def self.scientists_min(level)
    evalproperty('scientists.min', nil, 'level' => level).round
  end

  # Does this technology has damage mod?
  def damage_mod?; !! property('mod.damage'); end
  # Does this technology has armor mod?
  def armor_mod?; !! property('mod.armor'); end

  def damage_mod_formula; property('mod.damage').to_s; end
  def armor_mod_formula; property('mod.armor').to_s; end

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
    if not new_record? and scientists_changed? and \
        not just_finished? \
        and (paused? or finished?)
      errors.add(:base,
        "Cannot ajust scientist count when paused or finished!"
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
    player = self.player(true)
    player.scientists += scientists
    player.save!
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
end