#!/usr/bin/env ruby

# Recreates gone callbacks.

STDOUT.sync = true
require File.dirname(__FILE__) + '/../../lib/initializer.rb'
require File.dirname(__FILE__) + '/helpers/counter.rb'

now = Time.now.to_s(:db)

scope = Galaxy
Counter.new(scope, "Galaxy spawn").each do |galaxy|
  unless CallbackManager.has?(galaxy, CallbackManager::EVENT_SPAWN)
    CallbackManager.register(
      galaxy, CallbackManager::EVENT_SPAWN, Cfg.next_convoy_time
    )
  end
end

scope = SolarSystem.where("kind != ?", SolarSystem::KIND_WORMHOLE)
Counter.new(scope, "SS spawn").each do |solar_system|
  unless CallbackManager.has?(solar_system, CallbackManager::EVENT_SPAWN)
    CallbackManager.register(
      solar_system, CallbackManager::EVENT_SPAWN,
      Cfg.solar_system_spawn_random_delay_date(solar_system)
    )
  end
end

scope = SsObject::Asteroid
Counter.new(scope, "Asteroid spawn").each do |asteroid|
  unless CallbackManager.has?(asteroid, CallbackManager::EVENT_SPAWN)
    CallbackManager.register(
      asteroid, CallbackManager::EVENT_SPAWN,
      Cfg.asteroid_wreckage_next_spawn_date
    )
  end
end

scope = RouteHop.where("arrives_at <= '#{now}' AND next=1")
Counter.new(scope, "RouteHop").each do |hop|
  CallbackManager.register_or_update(
    hop, CallbackManager::EVENT_MOVEMENT, hop.arrives_at
  )
end

scope = SsObject::Planet.where("exploration_ends_at <= '#{now}'")
Counter.new(scope, "Planet Exploration").each do |planet|
  CallbackManager.register(
    planet,
    CallbackManager::EVENT_EXPLORATION_COMPLETE,
    planet.exploration_ends_at
  )
end

scope = SsObject::Planet.where("next_raid_at <= '#{now}'")
Counter.new(scope, "Planet Raids").each do |planet|
  CallbackManager.register(
    planet,
    CallbackManager::EVENT_RAID,
    planet.next_raid_at
  )
end

scope = SsObject::Planet.where("energy_diminish_registered=1")
Counter.new(scope, "Planet Energy Diminished").each do |planet|
  CallbackManager.register_or_update(
    planet,
    CallbackManager::EVENT_ENERGY_DIMINISHED,
    planet.last_resources_update + (planet.energy / planet.energy_rate).abs.ceil
  )
end

scope = Cooldown.where("ends_at <= '#{now}'")
Counter.new(scope, "Cooldown").each do |cooldown|
  CallbackManager.register(
    cooldown,
    CallbackManager::EVENT_DESTROY,
    cooldown.ends_at
  )
end

scope = Player.where("vip_creds_until <= '#{now}'")
Counter.new(scope, "Player VIP tick").each do |player|
  CallbackManager.register_or_update(
    player, CallbackManager::EVENT_VIP_TICK, player.vip_creds_until
  )
end

scope = Player.where("vip_until <= '#{now}'")
Counter.new(scope, "Player VIP until").each do |player|
  CallbackManager.register_or_update(
    player, CallbackManager::EVENT_VIP_STOP, player.vip_until
  )
end

scope = Technology.where("upgrade_ends_at <= '#{now}'")
Counter.new(scope, "Technology").each do |technology|
  CallbackManager.register_or_update(
    technology, CallbackManager::EVENT_UPGRADE_FINISHED,
    technology.upgrade_ends_at
  )
end

[Building, Unit].each do |klass|
  scope = klass.where("upgrade_ends_at <= '#{now}'")
  Counter.new(scope, klass.to_s).each do |obj|
    if obj.level == 0
      constructor = case obj
      when Unit
        Building.where(:constructable_unit_id => obj.id).first
      when Building
        Building.where(:constructable_building_id => obj.id).first
      else
        raise "Unknown constructable: #{obj.inspect}!"
      end

      CallbackManager.register_or_update(
        constructor, CallbackManager::EVENT_CONSTRUCTION_FINISHED,
        obj.upgrade_ends_at
      )
    else
      CallbackManager.register_or_update(
        obj, CallbackManager::EVENT_UPGRADE_FINISHED,
        obj.upgrade_ends_at
      )
    end
  end
end

scope = Building.where("cooldown_ends_at <= '#{now}'")
Counter.new(scope, "ResetableCooldownBuildings").each do |building|
  if building.is_a?(Parts::ResetableCooldown) ||
      building.is_a?(Parts::Repairable)
    CallbackManager.register_or_update(
      building, CallbackManager::EVENT_COOLDOWN_EXPIRED,
      building.cooldown_ends_at
    )
  end
end

puts
