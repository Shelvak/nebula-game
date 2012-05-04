# Class for storing rectangle parameters.
class Rectangle
  attr_accessor :x, :y, :x_end, :y_end

  # Mapping for using with ActiveRecord::Base#composed_of
  MAPPING = [
    [:x, :x],
    [:y, :y],
    [:x_end, :x_end],
    [:y_end, :y_end]
  ]

  # Create a rectangle. All coordinates are inclusive.
  def initialize(x, y, x_end, y_end)
    @x = x
    @y = y
    @x_end = x_end
    @y_end = y_end

    # Swap if passed in wrong order.
    @x, @x_end = @x_end, @x if x_end < x
    @y, @y_end = @y_end, @y if y_end < y
  end

  def width; @x_end - @x + 1; end
  def height; @y_end - @y + 1; end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && @x == other.x && @y == other.y &&
      @x_end == other.x_end && @y_end == other.y_end
  end

  def hash
    @x * 7 + @y * 7 + @x_end * 7 + @y_end * 13
  end

  def to_sql(galaxy_id, prefix="")
    "(`galaxy_id`=#{galaxy_id.to_i} AND `x` BETWEEN #{@x} AND #{@x_end
      } AND `y` BETWEEN #{@y} AND #{@y_end})"
  end

  def as_json(options=nil)
    {
      :x => @x,
      :x_end => @x_end,
      :y => @y,
      :y_end => @y_end
    }
  end
end
