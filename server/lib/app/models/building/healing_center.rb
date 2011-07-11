class Building::HealingCenter < Building
  include Parts::WithCooldown

  # Returns [metal, energy, zetium] needed to heal _unit_.
  def resources_for_healing(unit)
    percentage_to_heal = unit.damaged_percentage
    mod = cost_modifier
    metal = (unit.metal_cost * percentage_to_heal * mod).round
    energy = (unit.energy_cost * percentage_to_heal * mod).round
    zetium = (unit.zetium_cost * percentage_to_heal * mod).round

    [metal, energy, zetium]
  end

  def cost_modifier(level=nil)
    self.class.cost_modifier(level || self.level)
  end

  def self.cost_modifier(level)
    evalproperty('healing.cost.mod', nil, 'level' => level)
  end

  def healing_time(hp, level=nil)
    self.class.healing_time(hp, level || self.level)
  end

  def self.healing_time(hp, level)
    (hp * evalproperty('healing.time.mod', nil, 'level' => level)).ceil
  end

  def as_json(options=nil)
    super(options).merge(:cooldown_ends_at => cooldown_ends_at)
  end

  def heal!(units)
    raise GameLogicError.new(
      "Building must be active and without cooldown to heal!"
    ) unless active? && cooldown_expired?

    damaged_hp = 0
    metal = 0
    energy = 0
    zetium = 0

    units.each do |unit|
      raise GameLogicError.new("Unit #{unit} must be in same planet (#{
        planet_id}) as building to heal!") unless \
        unit.location_type == Location::SS_OBJECT &&
        unit.location_id == planet_id
      
      u_metal, u_energy, u_zetium = resources_for_healing(unit)
      metal += u_metal
      energy += u_energy
      zetium += u_zetium

      max_hp = unit.hit_points
      damaged_hp += max_hp - unit.hp
      unit.hp = max_hp
    end

    planet = self.planet
    raise GameLogicError.new(
      "Not enough resources to heal units! M: req:#{metal}/has:#{
        planet.metal}, E: req:#{energy}/has:#{planet.energy}, Z: req:#{
        zetium}/has:#{planet.zetium}"
    ) unless planet.metal >= metal && planet.energy >= energy &&
      planet.zetium >= zetium

    planet.metal -= metal
    planet.energy -= energy
    planet.zetium -= zetium

    self.cooldown_ends_at = healing_time(damaged_hp).seconds.from_now

    transaction do
      save!
      Unit.save_all_units(units)
      planet.save!
      
      EventBroker.fire(self, EventBroker::CHANGED)
      EventBroker.fire(planet, EventBroker::CHANGED, 
        EventBroker::REASON_OWNER_PROP_CHANGE)
      Objective::HealHp.progress(player, damaged_hp)
    end
  end
end