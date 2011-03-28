class UnitPointsCounter
  def initialize
    @points = {}
  end

  def add_unit(unit)
    # We need level to be less than actual because #points_on_upgrade
    # is called when unit is started to build, not when it's finished.
    
    unit.level -= 1
    attr = unit.class.points_attribute
    @points[attr] ||= 0
    @points[attr] += unit.points_on_upgrade
    unit.level += 1
  end

  def increase(player)
    @points.each do |attr, points|
      player.send("#{attr}=", player.send(attr) + points)
    end
  end
end
