# Configuration shortcuts instead of using strings everywhere.
class Cfg
  Java = ::Java::spacemule.modules.config.objects.Config

  class << self
    ### application.yml ###

    def control_token; CONFIG['control']['token']; end

    def required_client_version; CONFIG['client']['required_version']; end

    def development_galaxy?(ruleset)
      CONFIG['development', ruleset]
    end

    ### alliance.yml ###

    def alliance_take_over_owner_inactivity_time
      CONFIG.evalproperty('alliances.take_over.inactivity_time')
    end

    def alliance_leave_cooldown
      CONFIG.evalproperty('alliances.leave.cooldown')
    end

    ### battleground.yml ###

    def vps_for_winning
      CONFIG['battleground.victory.condition']
    end

    ### buildings.yml ###

    def rounding_precision
      CONFIG['buildings.resources.rounding_precision']
    end

    def buildings_self_destruct_creds_safeguard_time
      CONFIG.evalproperty('buildings.self_destruct.creds.safeguard_time')
    end

    def buildings_overdrive_output_multiplier
      CONFIG['buildings.overdrive.multiplier.output']
    end

    def buildings_overdrive_energy_usage_multiplier
      CONFIG['buildings.overdrive.multiplier.energy_usage']
    end

    ### chat.yml ###

    def chat_antiflood_messages; CONFIG['chat.antiflood.messages']; end

    def chat_antiflood_period; CONFIG['chat.antiflood.period']; end

    def chat_antiflood_silence_for(counter)
      CONFIG.evalproperty('chat.antiflood.silence_for', {'counter' => counter})
    end

    ### combat.yml ###

    def max_flanks; CONFIG['combat.flanks.max']; end

    def after_spawn_cooldown
      CONFIG.evalproperty('combat.cooldown.after_spawn.duration').from_now
    end

    def after_jump_cooldown
      CONFIG.evalproperty('combat.cooldown.after_jump.duration').from_now
    end

    ### creds.yml ###

    def creds_upgradable_speed_up_data
      CONFIG['creds.upgradable.speed_up']
    end

    # Returns [time, cost] for _index_.
    def creds_upgradable_speed_up_entry(index)
      entry = creds_upgradable_speed_up_data[index]
      raise ArgumentError, "Unknown speed up index #{index.inspect
        }, max index: #{creds_upgradable_speed_up_data.size - 1}!" \
        if entry.nil?

      time, cost = entry
      time = CONFIG.safe_eval(time) # Evaluate because it contains speed.
      [time, cost]
    end

    ### daily_bonus.yml ###

    def daily_bonus_start_points
      CONFIG['daily_bonus.start_points']
    end

    def daily_bonus_cooldown
      CONFIG['daily_bonus.cooldown']
    end

    def daily_bonus_ranges
      CONFIG['daily_bonus.ranges']
    end

    def daily_bonus_range(name)
      CONFIG["daily_bonus.range.#{name}"]
    end

    ### galaxy.yml ###

    def galaxy_zone_start_slot; CONFIG['galaxy.zone.start_slot']; end

    def galaxy_zone_max_player_count; CONFIG['galaxy.zone.players']; end

    def galaxy_zone_diameter; CONFIG['galaxy.zone.diameter']; end

    def galaxy_zone_maturity_age; CONFIG['galaxy.zone.maturity_age']; end

    # How much creds does player has on start.
    def player_starting_creds; CONFIG['galaxy.player.creds.starting']; end

    def player_max_population; CONFIG['galaxy.player.population.max']; end

    # Returns number of seconds player is required to be last seen ago to be
    # considered active.
    def player_inactivity_time(points)
      data = CONFIG['galaxy.player.inactivity_check']
      formula = nil
      data.each do |points_required, seconds|
        if points <= points_required
          formula = seconds
          break
        end
      end

      formula = data.last[1] if formula.nil?
      CONFIG.safe_eval(formula)
    end

    def player_referral_points_needed
      CONFIG['galaxy.player.referral.points_needed']
    end

    def galaxy_convoy_units_definition
      CONFIG["galaxy.convoy.units"]
    end

    def apocalypse_start_time
      CONFIG.evalproperty('galaxy.apocalypse.quiet_time').from_now
    end

    def apocalypse_survival_bonus(death_day)
      CONFIG.evalproperty('galaxy.apocalypse.survival_bonus', 'days' => death_day)
    end

    def next_convoy_time(wormholes)
      typesig binding, Fixnum

      CONFIG.evalproperty(
        'galaxy.convoy.time', 'wormholes' => wormholes
      ).from_now
    end

    def convoy_speed_modifier
      CONFIG['galaxy.convoy.speed_modifier']
    end

    ### market.yml ###

    # Minimal amount you can offer in market.
    def market_offer_min_amount; CONFIG['market.offer.min_amount']; end

    # Maximum number of market offers player can offer.
    def market_offers_max; CONFIG['market.offers.max']; end

    # How often are you able to cancel your offers?
    def market_offer_cancellation_cooldown
      CONFIG.evalproperty('market.offers.cancellation_cooldown')
    end

    # Returns +Float+ offset (like 0.10) for MarketOffer#to_rate deviation
    # from MarketOffer#average.
    def market_rate_offset; CONFIG['market.avg_rate.offset']; end

    # Minimal value for resource pair rate.
    def market_rate_min
      CONFIG['market.avg_rate.min_rate']
    end

    def market_rate_min_price_offset
      CONFIG['market.avg_rate.min_price.offset']
    end

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
    def market_bot_random_resource(galaxy_id, resource_kind)
      range = market_bot_resource_range(resource_kind)
      amount = rand(range.first, range.last + 1)
      amount * market_bot_resource_multiplier(galaxy_id)
    end

    # Returns +Range+ of how much seconds we should wait before creating new
    # system offer.
    def market_bot_resource_cooldown_range
      from, to = CONFIG["market.bot.resources.cooldown"]
      from = CONFIG.safe_eval(from)
      to = CONFIG.safe_eval(to)
      from..to
    end

    # Returns resource multiplier for given galaxy. This ensures amount of
    # resources stay relevant through course of the galaxy.
    def market_bot_resource_multiplier(galaxy_id)
      galaxy = without_locking { Galaxy.find(galaxy_id) }
      [1, galaxy.current_day / market_bot_resource_day_divider].max
    end

    def market_bot_resource_day_divider
      CONFIG['market.bot.resources.day_divider'].to_f
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

    def notification_expiration_time
      CONFIG.evalproperty('notifications.expiration_time')
    end

    def combat_log_expiration_time
      notification_expiration_time
    end

    ### raiding.yml ###

    def raiding_delay_range
      from, to = CONFIG['raiding.delay']
      from = CONFIG.safe_eval(from)
      to = CONFIG.safe_eval(to)
      from..to
    end

    def raiding_delay_range_from(time)
      range = raiding_delay_range
      (time + range.first)..(time + range.last)
    end

    def raiding_delay_random
      CONFIG.eval_hashrand('raiding.delay')
    end

    def raiding_config(key)
      config = CONFIG["raiding.raiders.#{key}"]
      raise ArgumentError.new("Unknown raiding config key #{key.inspect}!") \
        if config.nil?
      config
    end

    def raiding_max_arg(key)
      max_arg = CONFIG["raiding.raiders.#{key}.max_arg"]
      raise ArgumentError.new("Unknown raiding max_arg key #{key.inspect}!") \
        if max_arg.nil?
      max_arg
    end

    ### tiles.yml ###

    # Initializes exploration rewards and returns possible rewards.
    def exploration_rewards(key)
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

    def player_vip_tick_duration; CONFIG['creds.vip.tick.duration']; end

    def planet_boost_cost; CONFIG['creds.planet.resources.boost.cost']; end
    def planet_boost_duration
      CONFIG['creds.planet.resources.boost.duration']
    end

    def planet_boost_amount; CONFIG['creds.planet.resources.boost']; end

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

    # Cost to unlearn a technology.
    def technology_destroy_cost
      CONFIG['creds.technology.destroy']
    end

    ### units.yml ###

    def move_speed_modifier_range
      CONFIG['units.move.modifier.min']..CONFIG['units.move.modifier.max']
    end

    ### solar_system.yml ###

    def solar_system_orbit_count; CONFIG['solar_system.orbit.count']; end

    # Returns config key for spawn depending on _solar_system_kind_
    def solar_system_spawn_key(solar_system)
      "solar_system.spawn." + case solar_system.kind
      when SolarSystem::KIND_NORMAL
        solar_system.player_id.nil? ? "regular" : "home"
      when SolarSystem::KIND_BATTLEGROUND
        solar_system.main_battleground? ? "battleground" : "mini_battleground"
      when SolarSystem::KIND_POOLED
        "pooled"
      else
        raise ArgumentError,
          "Solar system #{solar_system} with unknown kind: #{solar_system.kind}"
      end
    end

    def solar_system_spawn_delay_range(solar_system)
      from, to = CONFIG[solar_system_spawn_key(solar_system) + ".delay"]
      from = CONFIG.safe_eval(from)
      to = CONFIG.safe_eval(to)
      from..to
    end

    def solar_system_spawn_random_delay(solar_system)
      range = solar_system_spawn_delay_range(solar_system)
      rand(range.first, range.last + 1)
    end

    def solar_system_spawn_random_delay_date(solar_system)
      solar_system_spawn_random_delay(solar_system).seconds.from_now
    end

    # Returns maximum number of spots with NPC ships in solar system.
    def solar_system_spawn_max_spots(solar_system)
      CONFIG[solar_system_spawn_key(solar_system) + ".max_spots"]
    end

    def solar_system_spawn_units_definition(solar_system)
      CONFIG[solar_system_spawn_key(solar_system) + ".units"]
    end

    def solar_system_spawn_strategy(solar_system)
      CONFIG[solar_system_spawn_key(solar_system) + ".strategy"]
    end

    ### ss_objects.yml ###

    def asteroid_wreckage_next_spawn
      CONFIG.eval_rangerand("ss_object.asteroid.wreckage.time.spawn")
    end

    def asteroid_wreckage_next_spawn_date
      asteroid_wreckage_next_spawn.from_now
    end
  end
end
