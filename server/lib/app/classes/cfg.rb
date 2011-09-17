# Configuration shortcuts instead of using strings everywhere.
class Cfg; class << self
  def control_token; CONFIG['control']['token']; end

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
    (from)..(to)
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

  # Number of notifications sent to player.
  def notification_limit; CONFIG['notifications.limit']; end

  # For how long planet is protected after protection is initiated?
  def planet_protection_duration
    CONFIG.evalproperty('combat.cooldown.protection.duration')
  end

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

  def player_initial_population; CONFIG['galaxy.player.population']; end
  def player_max_population; CONFIG['galaxy.player.population.max']; end

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

  def move_speed_modifier_range
    CONFIG['units.move.modifier.min']..CONFIG['units.move.modifier.max']
  end
end; end