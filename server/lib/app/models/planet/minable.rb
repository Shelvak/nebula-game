module Planet::Minable
  def self.included(other_mod)
    def other_mod.metal_rate
      CONFIG.hashrand "planet.#{to_s.demodulize.underscore}.rates.metal"
    end

    def other_mod.energy_rate
      CONFIG.hashrand "planet.#{to_s.demodulize.underscore}.rates.energy"
    end

    def other_mod.zetium_rate
      CONFIG.hashrand "planet.#{to_s.demodulize.underscore}.rates.zetium"
    end
    
    super(other_mod)
  end
end
