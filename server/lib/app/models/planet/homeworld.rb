class Planet::Homeworld < Planet
  include Landable

  class << self
    def get_dimensions(map)
      [(map[0].length.to_f / 2).ceil, map.size]
    end

    # Homeworlds are always of variation 0
    def variation; 0; end
  end

  def generate_dimensions
    self.width, self.height = self.class.get_dimensions(CONFIG['planet.homeworld.map'])
  end

  def generate_map
    nil
  end
end