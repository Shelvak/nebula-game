module Planet::Landable
  def self.included(other_mod)
    def other_mod.planet_class
      Planet::CLASS_LANDABLE
    end

    super(other_mod)
  end
end
