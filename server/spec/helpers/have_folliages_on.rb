RSpec::Matchers.define :have_folliages_on do |klass|
  match do |planet|
    if klass == Building
      @buildings = klass.where(:planet_id => planet.id)

      @items = @buildings.map do |building|
        items = Folliage.where(
          "planet_id=? AND (x BETWEEN ? AND ? AND y BETWEEN ? AND ?)",
          planet.id, building.x, building.x_end, building.y, building.y_end
        ).all
        items.blank? ? nil : [building, items]
      end.compact
    else
      raise ArgumentError.new("Don't know how to handle #{klass}!")
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
    "#{planet_str(planet)} should have folliages on #{
      klass} but it does not."
  end

  failure_message_for_should_not do |planet|
    "#{planet_str(planet)} should not have folliages on #{
      klass} but it does at:\n" +
      @items.map do |building, items|
        "On #{building_str(building)}: #{items.map { |f| "#{f.x},#{f.y}" }}"
      end.join("\n")
  end
end