#!/usr/bin/env ruby

# Recreates gone callbacks.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'
require File.dirname(__FILE__) + '/helpers/counter.rb'

if ARGV.include?("--help") || ARGV.size == 0
  puts "Usage: ruby fix_callbacks.rb options"
  puts
  puts "Where options are:"
  puts "  --future: wipe all callbacks and recreate future callbacks as well."
  puts "  --all: select which callbacks you want fixed."
  puts "    --misc:"
  puts "      --combat-log"
  puts "      --notification"
  puts "    --galaxy"
  puts "    --solar-system"
  puts "    --asteroid"
  puts "    --route-hop"
  puts "    --planet:"
  puts "      --exploration"
  puts "      --raid"
  puts "      --energy-diminish"
  puts "    --cooldown"
  puts "    --player:"
  puts "      --vip-tick"
  puts "      --vip-until"
  puts "      --player-inactive"
  puts "    --convoy"
  puts "    --technology"
  puts "    --unit"
  puts "    --building:"
  puts "      --building-cooldown"
  exit 0
end

future_as_well = ARGV.include?("--future")
puts "Working on future callbacks as well!" if future_as_well
now = Time.now.to_s(:db)

def run?(*args)
  switches = ["--all"] + args.map { |s| "--#{s}" }
  ARGV.any? { |a| switches.include?(a) }
end

if run?("misc", "combat-log")
  scope = CombatLog.select("id")
  Counter.new(
    scope, "CombatLog destroy",
    lambda { |s, &block| s.c_select_values.each(&block) },
    lambda { |id| id }
  ).each do |id|
    # Fake our combat logs
    log = CombatLog.new
    log.id = id

    CallbackManager.register_or_update(
      log, CallbackManager::EVENT_DESTROY,
      (Cfg.combat_log_expiration_time + rand(2.days)).from_now
    )
  end
end

if run?("misc", "notification")
  scope = future_as_well \
    ? Notification \
    : Notification.where("expires_at <= '#{now}'")
  Counter.new(scope, "Notification destroy").each do |notification|
    CallbackManager.register_or_update(
      notification, CallbackManager::EVENT_DESTROY, notification.expires_at
    )
  end
end

if run?("galaxy")
  scope = Galaxy
  Counter.new(scope, "Galaxy").each do |galaxy|
    unless CallbackManager.has?(galaxy, CallbackManager::EVENT_SPAWN)
      CallbackManager.register(
        galaxy, CallbackManager::EVENT_SPAWN, Cfg.next_convoy_time
      )
    end

    {
      MarketOffer::KIND_METAL => CallbackManager::EVENT_CREATE_METAL_SYSTEM_OFFER,
      MarketOffer::KIND_ENERGY =>
        CallbackManager::EVENT_CREATE_ENERGY_SYSTEM_OFFER,
      MarketOffer::KIND_ZETIUM =>
        CallbackManager::EVENT_CREATE_ZETIUM_SYSTEM_OFFER
    }.each do |kind, event|
      if ! galaxy.market_offers.by_system.
          where(:from_kind => kind, :to_kind => MarketOffer::KIND_CREDS).exists?
        CallbackManager.register(galaxy, event, Time.now)
      end
    end
  end
end

if run?("solar-system")
  scope = SolarSystem.where("kind != ?", SolarSystem::KIND_WORMHOLE)
  Counter.new(scope, "SS spawn").each do |solar_system|
    unless CallbackManager.has?(solar_system, CallbackManager::EVENT_SPAWN)
      CallbackManager.register(
        solar_system, CallbackManager::EVENT_SPAWN,
        Cfg.solar_system_spawn_random_delay_date(solar_system)
      )
    end
  end
end

if run?("asteroid")
  scope = SsObject::Asteroid
  Counter.new(scope, "Asteroid spawn").each do |asteroid|
    unless CallbackManager.has?(asteroid, CallbackManager::EVENT_SPAWN)
      CallbackManager.register(
        asteroid, CallbackManager::EVENT_SPAWN,
        Cfg.asteroid_wreckage_next_spawn_date
      )
    end
  end
end

if run?("route-hop")
  scope = future_as_well \
    ? RouteHop.where("next=1") \
    : RouteHop.where("arrives_at <= '#{now}' AND next=1")
  Counter.new(scope, "RouteHop").each do |hop|
    CallbackManager.register_or_update(
      hop, CallbackManager::EVENT_MOVEMENT, hop.arrives_at
    )
  end
end

if run?("planet", "exploration")
  scope = future_as_well \
    ? SsObject::Planet.where("exploration_ends_at IS NOT NULL") \
    : SsObject::Planet.where("exploration_ends_at <= '#{now}'")
  Counter.new(scope, "Planet Exploration").each do |planet|
    CallbackManager.register(
      planet,
      CallbackManager::EVENT_EXPLORATION_COMPLETE,
      planet.exploration_ends_at
    )
  end
end

if run?("planet", "raid")
  scope = future_as_well \
    ? SsObject::Planet.where("next_raid_at IS NOT NULL") \
    : SsObject::Planet.where("next_raid_at <= '#{now}'")
  Counter.new(scope, "Planet Raids").each do |planet|
    CallbackManager.register_or_update(
      planet,
      CallbackManager::EVENT_RAID,
      planet.next_raid_at
    )
  end
end

if run?("planet", "energy-diminish")
  scope = SsObject::Planet.where("energy_diminish_registered=1")
  Counter.new(scope, "Planet Energy Diminished").each do |planet|
    CallbackManager.register_or_update(
      planet,
      CallbackManager::EVENT_ENERGY_DIMINISHED,
      planet.last_resources_update + (planet.energy / planet.energy_rate).abs.
        ceil
    )
  end
end

if run?("cooldown")
  scope = future_as_well \
    ? Cooldown.where("ends_at IS NOT NULL") \
    : Cooldown.where("ends_at <= '#{now}'")
  Counter.new(scope, "Cooldown").each do |cooldown|
    CallbackManager.register(
      cooldown,
      CallbackManager::EVENT_DESTROY,
      cooldown.ends_at
    )
  end
end

if run?("player", "vip-tick")
  scope = future_as_well \
    ? Player.where("vip_creds_until IS NOT NULL") \
    : Player.where("vip_creds_until <= '#{now}'")
  Counter.new(scope, "Player VIP tick").each do |player|
    CallbackManager.register_or_update(
      player, CallbackManager::EVENT_VIP_TICK, player.vip_creds_until
    )
  end
end

if run?("player", "vip-until")
  scope = future_as_well \
    ? Player.where("vip_until IS NOT NULL") \
    : Player.where("vip_until <= '#{now}'")
  Counter.new(scope, "Player VIP until").each do |player|
    CallbackManager.register_or_update(
      player, CallbackManager::EVENT_VIP_STOP, player.vip_until
    )
  end
end

if run?("player", "player-inactive")
  scope = Player
  Counter.new(scope, "Player inactive").each do |player|
    CallbackManager.register_or_update(
      player, CallbackManager::EVENT_CHECK_INACTIVE_PLAYER,
      Cfg.player_inactivity_time(player.points).from_now
    )
  end
end

if run?("technology")
  scope = future_as_well \
    ? Technology.where("upgrade_ends_at IS NOT NULL") \
    : Technology.where("upgrade_ends_at <= '#{now}'")
  Counter.new(scope, "Technology").each do |technology|
    CallbackManager.register_or_update(
      technology, CallbackManager::EVENT_UPGRADE_FINISHED,
      technology.upgrade_ends_at
    )
  end
end

if run?("convoy")
  scope = Unit.where(:player_id => nil).where("route_id IS NOT NULL")
  route_cache ||= {}
  Counter.new(scope, "NPC convoys").each do |unit|
    route = route_cache[unit.route_id] ||= unit.route
    CallbackManager.register_or_update(
      unit, CallbackManager::EVENT_DESTROY,
      # If we destroy units at same time as they arrive to their
      # destination then callback execution order is not determined and
      # units can be destroyed before they make their final hop. This
      # causes problems in the client, therefore we ensure that destroy
      # callbacks will be executed after last hop.
      route.arrives_at + 1
    )
  end
end

building_unit = lambda do |klass|
  scope = future_as_well \
    ? klass.where("upgrade_ends_at IS NOT NULL") \
    : klass.where("upgrade_ends_at <= '#{now}'")
  Counter.new(scope, klass.to_s).each do |obj|
    constructor = \
      if obj.level == 0
        case obj
        when Unit
          Building.where(:constructable_unit_id => obj.id).first
        when Building
          Building.where(:constructable_building_id => obj.id).first
        else
          raise "Unknown constructable: #{obj.inspect}!"
        end
      else
        nil
      end

    if constructor.nil?
      # Self-deployed or upgrading.
      CallbackManager.register_or_update(
        obj, CallbackManager::EVENT_UPGRADE_FINISHED,
        obj.upgrade_ends_at
      )
    else
      # Constructor deployed.
      CallbackManager.register_or_update(
        constructor, CallbackManager::EVENT_CONSTRUCTION_FINISHED,
        obj.upgrade_ends_at
      )
    end
  end
end

building_unit[Building] if run?("building")
building_unit[Unit] if run?("unit")

if run?("building", "building-cooldown")
  scope = future_as_well \
    ? Building.where("cooldown_ends_at IS NOT NULL") \
    : Building.where("cooldown_ends_at <= '#{now}'")
  Counter.new(scope, "ResetableCooldownBuildings").each do |building|
    if building.is_a?(Parts::ResetableCooldown) ||
        building.is_a?(Parts::Repairable)
      CallbackManager.register_or_update(
        building, CallbackManager::EVENT_COOLDOWN_EXPIRED,
        building.cooldown_ends_at
      )
    end
  end
end

puts
