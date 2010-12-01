Spec::Matchers.define :have_blank_npc_buildings do
  match do |planet|
    @items = []

    planet.buildings.each do |building|
      @items.push building if building.npc? && building.units.blank?
    end

    @items != []
  end

  def planet_str(planet)
    "Planet(id: #{planet.id}, w: #{planet.width}, h: #{planet.height
      }, pid: #{planet.player_id})"
  end

  def building_str(building)
    "Building(#{building.x},#{building.y}->#{
      building.x_end},#{building.y_end}: #{building.type})"
  end

  failure_message_for_should do |planet|
    "#{planet_str(planet)} should have blank npc buildings but it does not."
  end

  failure_message_for_should_not do |planet|
    "#{planet_str(planet)} should not have blank npc buildings " +
    "but it does:\n" +
      @items.map do |building|
        "#{building_str(building)}"
      end.join("\n")
  end
end