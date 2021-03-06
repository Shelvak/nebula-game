class Building::HealingCenter < Building
  include Parts::WithCooldown
  include Parts::Healing

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
        unit.location.type == Location::SS_OBJECT &&
        unit.location.id == planet_id
      
      u_metal, u_energy, u_zetium = resources_for_healing(unit)
      metal += u_metal
      energy += u_energy
      zetium += u_zetium

      damaged_hp += unit.damaged_hp
      unit.hp_percentage = 1
    end

    planet = self.planet
    raise GameLogicError.new(
      "Not enough resources to heal units! M: req:#{metal}/has:#{
        planet.metal}, E: req:#{energy}/has:#{planet.energy}, Z: req:#{
        zetium}/has:#{planet.zetium}"
    ) unless planet.metal >= metal && planet.energy >= energy &&
      planet.zetium >= zetium

    self.cooldown_ends_at = healing_time(damaged_hp).seconds.from_now

    save!
    Unit.save_all_units(units)
    planet.increase!(:metal => -metal, :energy => -energy, :zetium => -zetium)

    EventBroker.fire(self, EventBroker::CHANGED)
    Objective::HealHp.progress(player, damaged_hp)
  end
end