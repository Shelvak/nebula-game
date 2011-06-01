class SsObject::Asteroid < SsObject
  def to_s
    super + "Asteroid " +
      "  metal: #{metal_rate}/#{metal_storage}\n" +
      "  energy: #{energy_rate}/#{energy_storage}\n" +
      "  zetium: #{zetium_rate}/#{zetium_storage}\n" +
      ">"
  end

  # Attributes which are also included for Asteroid subtype.
  RESOURCE_ATTRIBUTES = %w{metal_rate metal_storage
    energy_rate energy_storage zetium_rate zetium_storage}

  # Returns Asteroid JSON representation. It's basically same as
  # SsObject#as_json but includes additional fields.
  #
  # Options:
  # - :resources - includes resources attributes.
  #
  def as_json(options=nil)
    additional = {}
    if options && options[:resources]
      read_attributes(RESOURCE_ATTRIBUTES, additional)
    end

    super(options).merge(additional)
  end

  def spawn_resources!
    metal = metal_rate * CONFIG.rangerand(
      "ss_object.asteroid.wreckage.metal.spawn")
    energy = energy_rate * CONFIG.rangerand(
      "ss_object.asteroid.wreckage.energy.spawn")
    zetium = zetium_rate * CONFIG.rangerand(
      "ss_object.asteroid.wreckage.zetium.spawn")
    Wreckage.add(solar_system_point, metal, energy, zetium)
    CallbackManager.register(self, CallbackManager::EVENT_SPAWN,
      CONFIG.eval_rangerand(
        "ss_object.asteroid.wreckage.time.spawn").from_now)
  end

  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_SPAWN
      find(id).spawn_resources!
    else
      raise CallbackManager::UnknownEvent.new(self, id, event)
    end
  end
end