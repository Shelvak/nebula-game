# Represents a flank of units in the battlefield
class Combat::Flank
  include Enumerable

  KIND_GROUND = Parts::Shooting::KIND_GROUND
  KIND_SPACE = Parts::Shooting::KIND_SPACE
  
  attr_reader :size

  def initialize(alliance, flank_index, units=[])
    @alliance = alliance
    @flank_index = flank_index
    @units = {
      KIND_GROUND => [],
      KIND_SPACE => []
    }
    @size = 0

    units.each do |unit|
      push unit
    end
  end

  def push(unit)
    if unit.ground?
      @units[KIND_GROUND].push unit
    else
      @units[KIND_SPACE].push unit
    end
    @size += 1
  end

  def delete(unit)
    if unit.ground?
      @units[KIND_GROUND].delete(unit)
    else
      @units[KIND_SPACE].delete(unit)
    end
    @size -= 1

    @alliance.delete(@flank_index) if @size == 0
  end

  # Does this flank has units reachable by _reach_.
  def has?(reach)
    @units[reach].present?
  end

  def shuffle!
    @units[KIND_GROUND].shuffle!
    @units[KIND_SPACE].shuffle!
    true
  end

  def each
    @units[KIND_GROUND].each { |unit| yield unit }
    @units[KIND_SPACE].each { |unit| yield unit }
  end

  def [](index)
    ground_size = @units[KIND_GROUND].size
    index < ground_size \
      ? @units[KIND_GROUND][index] \
      : @units[KIND_SPACE][index - ground_size]
  end

  def rand(reach)
    case reach
    when KIND_GROUND
      @units[KIND_GROUND].random_element
    when KIND_SPACE
      @units[KIND_SPACE].random_element
    # Both ground and space
    else
      self[rand(@size)]
    end
  end

  def as_json(options=nil)
    @units
  end
end
