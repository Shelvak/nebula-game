class UnitPointsCounter
  def initialize
    @points = {}
  end

  def add_unit(unit)
    attr = unit.class.points_attribute
    @points[attr] ||= 0
    @points[attr] += unit.points_on_upgrade
  end

  def increase(player)
    @points.each do |attr, points|
      player.send("#{attr}=", player.send(attr) + points)
    end
  end
end
