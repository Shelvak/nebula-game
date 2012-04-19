class SsObject::Asteroid < SsObject
  def to_s
    (super + "Asteroid m: %3.4f, e: %3.4f, z: %3.4f>") % [
      metal_generation_rate, energy_generation_rate, zetium_generation_rate
    ]
  end

  # Returns [metal, energy, zetium] currently positioned on top of this
  # asteroid.
  def current_resources
    wreckage = Wreckage.in_location(solar_system_point).first
    wreckage.nil? \
      ? [0, 0, 0] \
      : [wreckage.metal, wreckage.energy, wreckage.zetium]
  end
  
  # Returns modifiers for resource spawning.
  def spawn_modifiers
    current_metal, current_energy, current_zetium = current_resources
    max_metal = CONFIG['ss_object.asteroid.wreckage.metal.spawn.max']
    max_energy = CONFIG['ss_object.asteroid.wreckage.energy.spawn.max']
    max_zetium = CONFIG['ss_object.asteroid.wreckage.zetium.spawn.max']
    
    [
      [0, 1 - (current_metal / max_metal)].max,
      [0, 1 - (current_energy / max_energy)].max,
      [0, 1 - (current_zetium / max_zetium)].max
    ]
  end

  def spawn_resources!
    metal_mod, energy_mod, zetium_mod = spawn_modifiers
    
    metal = metal_generation_rate * CONFIG.random_from(
      "ss_object.asteroid.wreckage.metal.spawn") * metal_mod
    energy = energy_generation_rate * CONFIG.random_from(
      "ss_object.asteroid.wreckage.energy.spawn") * energy_mod
    zetium = zetium_generation_rate * CONFIG.random_from(
      "ss_object.asteroid.wreckage.zetium.spawn") * zetium_mod
    Wreckage.add(solar_system_point, metal, energy, zetium)
    CallbackManager.register(
      self, CallbackManager::EVENT_SPAWN,
      Cfg.asteroid_wreckage_next_spawn_date
    )
  end
end