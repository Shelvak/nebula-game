# Represents a flank of units in the battlefield
class Combat::Flank
  include Enumerable
  
  attr_reader :size

  def initialize(alliance, flank_index, units=[])
    @alliance = alliance
    @flank_index = flank_index
    @units = {
      :ground => [],
      :space => []
    }
    @size = 0

    units.each do |unit|
      push unit
    end
  end

  def push(unit)
    if unit.ground?
      @units[:ground].push unit
    else
      @units[:space].push unit
    end
    @size += 1
  end

  def delete(unit)
    if unit.ground?
      @units[:ground].delete(unit)
    else
      @units[:space].delete(unit)
    end
    @size -= 1

    @alliance.delete(@flank_index) if @size == 0
  end

  # Does this flank has units reacheble by _reach_.
  def has?(reach)
    @units[reach].present?
  end

  def shuffle!
    @units[:ground].shuffle!
    @units[:space].shuffle!
    true
  end

  def each
    @units[:ground].each { |unit| yield unit }
    @units[:space].each { |unit| yield unit }
  end

  def [](index)
    ground_size = @units[:ground].size
    index < ground_size \
      ? @units[:ground][index] \
      : @units[:space][index - ground_size]
  end

  def rand(reach)
    case reach
    when :ground
      @units[:ground].random_element
    when :space
      @units[:space].random_element
    # Both ground and space
    else
      self[rand(@size)]
    end
  end

  def as_json(options=nil)
    @units
  end
end
