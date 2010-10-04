module Planet::Unlandable
  def self.included(other_mod)
    def other_mod.planet_class
      Planet::CLASS_UNLANDABLE
    end
    
    super(other_mod)
  end

  def generate_dimensions
    self.width = nil
    self.height = nil
  end

  def generate_map
    nil
  end
end
