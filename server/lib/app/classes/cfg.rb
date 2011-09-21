# Configuration shortcuts instead of using strings everywhere.
class Cfg; class << self
  ### application.yml ###

  def control_token; CONFIG['control']['token']; end

  ### buildings.yml ###

  def buildings_overdrive_output_multiplier
    CONFIG['buildings.overdrive.multiplier.output']
  end

  def buildings_overdrive_energy_usage_multiplier
    CONFIG['buildings.overdrive.multiplier.energy_usage']
  end

  ### market.yml ###

  # Minimal amount you can offer in market.
  def market_offer_min_amount; CONFIG['market.offer.min_amount']; end

  # Maximum number of market offers player can offer.
  def market_offers_max; CONFIG['market.offers.max']; end

  # Returns +Float+ offset (like 0.10) for MarketOffer#to_rate deviation 
  # from MarketOffer#average.
  def market_rate_offset; CONFIG['market.avg_rate.offset']; end

  # Returns [seed_amount, seed_rate] for resource pair.
  def market_seed(from_kind, to_kind)
    pair = CONFIG[
      "market.average.seed.#{from_kind}.#{to_kind}"
    ]
    raise ArgumentError.new("Unknown kind pair! from_kind: #{
      from_kind.inspect}, to_kind: #{to_kind.inspect}") if pair.nil?
    pair
  end

  # Returns +Range+ for market resources bot for resource of kind
  # _resource_kind_.
  def market_bot_resource_range(resource_kind)
    (
      CONFIG["market.bot.resources.range.#{resource_kind}"][0]
    )..(
      CONFIG["market.bot.resources.range.#{resource_kind}"][1]
    )
  end

  # Returns random resource amount for market resources bot for
  # resource kind _resource_kind_.
  def market_bot_random_resource(resource_kind)
    range = market_bot_resource_range(resource_kind)
    rand(range.first, range.last + 1)
  end

  # Returns +Range+ of how much seconds we should wait before creating new
  # system offer.
  def market_bot_resource_cooldown_range
    from, to = CONFIG["market.bot.resources.cooldown"]
    from = CONFIG.safe_eval(from)
    to = CONFIG.safe_eval(to)
    from..to
  end

  # Returns random number of seconds we should wait before creating new
  # system offer.
  def market_bot_random_resource_cooldown
    range = market_bot_resource_cooldown_range
    rand(range.first, range.last + 1)
  end

  # Returns random +Time+ when new system offer should be created.
  def market_bot_random_resource_cooldown_date
    market_bot_random_resource_cooldown.seconds.from_now
  end

  ### notifications.yml ###

  # Number of notifications sent to player.
  def notification_limit; CONFIG['notifications.limit']; end

  ### combat.yml ###

  # For how long planet is protected after protection is initiated?
  def planet_protection_duration
    CONFIG.evalproperty('combat.cooldown.protection.duration')
  end

  ### galaxy.yml ###

  def player_initial_population; CONFIG['galaxy.player.population']; end
  def player_max_population; CONFIG['galaxy.player.population.max']; end

  def galaxy_convoy_units_definition
    CONFIG["galaxy.convoy.units"]
  end

  ### tiles.yml ###

  # Initializes exploration rewards and returns possible rewards.
  def exploration_rewards(key)
    ExplorationRewardsInitializer.initialize
    CONFIG["tiles.exploration.rewards.#{key}"]
  end

  # Returns one random weighted reward.
  def exploration_rewards_random(key)
    exploration_rewards(key).
      weighted_random { |item| item['weight'] }['rewards']
  end

  # Returns chance [0..100] of finding something useful in exploration.
  def exploration_win_chance(width, height)
    CONFIG.evalproperty("tiles.exploration.winning_chance",
      'width' => width, 'height' => height).round
  end

  ### creds.yml ###

  def planet_boost_cost; CONFIG['creds.planet.resources.boost.cost']; end
  def planet_boost_duration
    CONFIG['creds.planet.resources.boost.duration']
  end

  def units_speed_up(speed_modifier, hop_count)
    [
      CONFIG.evalproperty('creds.move.speed_up',
        'percentage' => (1.0 - speed_modifier),
        'hop_count' => hop_count
      ).round,
      CONFIG['creds.move.speed_up.max_cost']
    ].min
  end

  # Returns number of creds required to remove a foliage.
  def foliage_removal_cost(width, height)
    CONFIG.evalproperty("creds.foliage.remove",
      'width' => width, 'height' => height).round
  end

  # Returns number of creds required to instantly finish an exploration.
  def exploration_finish_cost(width, height)
    CONFIG.evalproperty("creds.exploration.finish",
      'width' => width, 'height' => height).round
  end

  ### units.yml ###

  def move_speed_modifier_range
    CONFIG['units.move.modifier.min']..CONFIG['units.move.modifier.max']
  end

  ### solar_system.yml ###

  def solar_system_orbit_count; CONFIG['solar_system.orbit.count']; end

  # Returns config key for spawn depending on _solar_system_kind_
  def solar_system_spawn_key(solar_system_kind)
    "solar_system.spawn." + case solar_system_kind
    when SolarSystem::KIND_NORMAL
      "regular"
    when SolarSystem::KIND_BATTLEGROUND
      "battleground"
    else
      raise ArgumentError.new("Unknown solar system kind: #{
        solar_system_kind.inspect}")
    end
  end

  def solar_system_spawn_delay_range(solar_system_kind)
    from, to = CONFIG[solar_system_spawn_key(solar_system_kind) + ".delay"]
    from = CONFIG.safe_eval(from)
    to = CONFIG.safe_eval(to)
    from..to
  end

  def solar_system_spawn_random_delay(solar_system_kind)
    range = solar_system_spawn_delay_range(solar_system_kind)
    rand(range.first, range.last + 1)
  end

  def solar_system_spawn_random_delay_date(solar_system_kind)
    solar_system_spawn_random_delay(solar_system_kind).seconds.from_now
  end

  # Returns maximum number of spots with NPC ships in solar system.
  def solar_system_spawn_max_spots(solar_system_kind)
    CONFIG[solar_system_spawn_key(solar_system_kind) + ".max_spots"]
  end

  def solar_system_spawn_units_definition(solar_system_kind)
    CONFIG[solar_system_spawn_key(solar_system_kind) + ".units"]
  end

  def solar_system_spawn_strategy(solar_system_kind)
    CONFIG[solar_system_spawn_key(solar_system_kind) + ".strategy"]
  end
end; end