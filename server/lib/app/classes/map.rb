class Map
  class << self
    # Return [_width_, _height_] for given _type_ planet area.
    def dimensions_for_area(type)
      proportion = area = max_area = nil
      CONFIG.with_scope('planet') do
        proportion = CONFIG.hashrand('area.proportion').to_f
        area = CONFIG.hashrand("#{type}.area").to_f
        max_area = CONFIG['area.max']
      end
      raise ArgumentError.new(
        "Area size is #{area} and that is greater than planet.area.max=#{
        max_area} that is defined in config!") if area > max_area

      width = ((100 * area) / (100 + proportion)).round
      height = (area - width).round
      [width, height]
    end
  end
end
