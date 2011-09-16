RSpec::Matchers.define :have_offmap do |klass|
  match do |planet|
    if klass == Tile || klass == Folliage
      @items = klass.where(
        "planet_id=? AND (x < 0 OR y < 0 OR x >= ? OR y >= ?)",
        planet.id, planet.width, planet.height
      ).all
    elsif klass == Building
      @items = klass.where(
        "planet_id=? AND (x < 0 OR y < 0 OR x_end >= ? OR y_end >= ?)",
        planet.id, planet.width, planet.height
      ).all
    else
      raise ArgumentError.new("Don't know how to match #{klass}!")
    end

    @items != []
  end

  def planet_str(planet)
    "Planet(id: #{planet.id}, w: #{planet.width}, h: #{planet.height
      }, pid: #{planet.player_id})"
  end

  failure_message_for_should do |planet|
    "#{planet_str(planet)} should have #{klass} offmap but it does not."
  end

  failure_message_for_should_not do |planet|
    "#{planet_str(planet)} should not have #{klass
      } offmap but it does at:\n" +
      @items.map do |item|
        case item
        when Tile, Folliage
          "#{item.x},#{item.y}"
        when Building
          "#{item.x},#{item.y}->#{item.x_end},#{item.y_end}"
        end
      end.join(" ")
  end
end