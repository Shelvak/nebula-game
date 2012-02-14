class RaidSpawner
  # It's a regular planet.
  KEY_PLANET = 'planet'
  # It's a battleground planet.
  KEY_BATTLEGROUND = 'battleground'
  # Apocalypse is raging in the galaxy.
  KEY_APOCALYPSE = 'apocalypse'

  def initialize(planet)
    @planet = planet
  end

  # Creates raiders and raids planet. Registers new raid.
  def raid!
    raiders = units
    unless raiders.blank?
      Unit.save_all_units(raiders, nil, EventBroker::CREATED)
      # TODO: spec me
      Cooldown.create_unless_exists(
        @planet.location_point, Cfg.after_spawn_cooldown
      )
    end
    register!
  end

  private
  # Registers next raid on planet.
  def register!
    @planet.next_raid_at += Cfg.raiding_delay_random
    @planet.raid_arg = generate_arg
    CallbackManager.register_or_update(
      @planet, CallbackManager::EVENT_RAID, @planet.next_raid_at
    )
    @planet.delayed_fire(@planet, EventBroker::CHANGED,
                         EventBroker::REASON_OWNER_PROP_CHANGE)
    @planet.save!
  end

  # Return raid configuration key for spawners planet.
  def key
    return KEY_APOCALYPSE if apocalypse?
    return KEY_BATTLEGROUND if battleground?
    KEY_PLANET
  end

  # Returns raid argument that should be stored to database.
  def generate_arg
    return 0 if @planet.player_id.nil? || apocalypse? ||
      ! @planet.solar_system.player_id.nil?

    arg = battleground? \
      ? @planet.player.bg_planets_count : @planet.player.planets_count
    
    [arg, Cfg.raiding_max_arg(key)].min
  end

  # Return array of built (but not saved) units.
  def units
    definitions = unit_counts
    galaxy_id = @planet.solar_system.galaxy_id

    units = []
    definitions.each do |type, count, flank|
      klass = "Unit::#{type.camelcase}".constantize
      count.times do
        unit = klass.new(
          :level => 1,
          :location => @planet,
          :galaxy_id => galaxy_id,
          :flank => flank
        )
        unit.skip_validate_technologies = true

        units.push unit
      end
    end

    units
  end

  # Return what units will raid player if he has _planets_ planets.
  #
  # Returns Array:
  # [
  #   [type, count, flank],
  #   ...
  # ]
  #
  def unit_counts
    # No raiders if apocalypse and planet is not occupied.
    return [] if apocalypse? && @planet.player_id.nil?

    units = {}
    max_flanks = Cfg.max_flanks

    raid_arg = apocalypse? ? apocalypse_raid_arg : @planet.raid_arg

    params = {'arg' => raid_arg}
    calc = lambda do |formula|
      begin
        value = CONFIG.safe_eval(formula, params)
        # If we went to complex numbers, that means we did something strange and
        # the result is bad.
        return 0 if value.is_a?(Complex)
        [0, value.round].max
      rescue FloatDomainError; 0; end
    end

    Cfg.raiding_config(key).each do
      |type, (from_formula, to_formula, chance_formula)|

      units[type] = {}
      max_flanks.times { |flank| units[type][flank] = 0 }

      from = calc[from_formula]
      to = calc[to_formula]
      chance = [calc[chance_formula], 1.0].min

      # Add the minimum.
      from.times do
        flank = rand(max_flanks)
        units[type][flank] += 1
      end

      # Add additional ones.
      (to - from).times do
        if rand <= chance
          flank = rand(max_flanks)
          units[type][flank] += 1
        end
      end
    end

    raiders = []
    units.each do |type, flanks|
      flanks.each do |index, count|
        raiders.push [type, count, index] unless count == 0
      end
    end

    raiders
  end

  # Has the apocalypse started?
  def apocalypse?
    @_apocalypse ||= @planet.solar_system.galaxy.apocalypse_started?
  end

  # Current apocalypse day.
  def apocalypse_raid_arg
    @planet.solar_system.galaxy.apocalypse_day(@planet.next_raid_at)
  end

  def battleground?
    @_battleground ||= @planet.solar_system.battleground?
  end
end
