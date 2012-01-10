# This file generates:
# * CONFIG[tiles.exploration.rewards.win.with_units]
# * CONFIG[tiles.exploration.rewards.win.without_units]
# * CONFIG[tiles.exploration.rewards.lose.with_units]
# * CONFIG[tiles.exploration.rewards.lose.without_units]
#
# And fills it with random rewards. Bigger reward means less chance of
# getting it. Configuration for this generator is done in sections/tiles.yml
# file.

# Create initializer which can be called as needed.
class ExplorationRewardsInitializer < GameConfig::Initializer
  # Divider for all calculated weights.
  STARTING_POINT = 100_000.0
  # Multiplier to tweak probabilities
  METAL_MULT = 4
  ENERGY_MULT = 2
  ZETIUM_MULT = 30
  UNIT_MULT = 4
  
  class << self
    def add(side, item)
      CONFIG["tiles.exploration.rewards.#{side}"] ||= []
      CONFIG["tiles.exploration.rewards.#{side}"].push item
    end
    
    def calculate_weight(metal, energy, zetium)
      total = metal * METAL_MULT + energy * ENERGY_MULT + 
        zetium * ZETIUM_MULT
      total = (total / STARTING_POINT).round
      # If it is so small, give it at least 1 weight.
      total == 0 ? 1 : total
    end
    
    def item(metal, energy, zetium, unit_type, unit_count, unit_hp)        
      weight = 0
      rewards = []

      if unit_count > 0
        klass = "Unit::#{unit_type.camelcase}".constantize
        hp_f = unit_hp.to_f / 100
        unit_metal = klass.metal_cost(1) * unit_count * UNIT_MULT * hp_f
        unit_energy = klass.energy_cost(1) * unit_count * UNIT_MULT * hp_f
        unit_zetium = klass.zetium_cost(1) * unit_count * UNIT_MULT * hp_f
        weight += calculate_weight(unit_metal, unit_energy, unit_zetium)
        rewards.push("kind" => Rewards::UNITS, "type" => unit_type,
          "count" => unit_count, "hp" => unit_hp)
      end

      rewards.push("kind" => Rewards::METAL, "count" => metal) if metal > 0
      rewards.push("kind" => Rewards::ENERGY, "count" => energy) if energy > 0
      rewards.push("kind" => Rewards::ZETIUM, "count" => zetium) if zetium > 0
      weight += calculate_weight(metal, energy, zetium)

      raise \
        ("Rewards are empty! metal: %3.4f, energy: %3.4f, " +
        "zetium: %3.4f, unit_type: %s, unit_count: %d, unit_hp: %d") % [
          metal, energy, zetium, unit_type, unit_count, unit_hp
        ] if rewards.blank?

      raise "Weight cannot be less than 1 for #{rewards.inspect} but was #{
        weight.inspect}!" if weight < 1
      {
        "weight" => weight,
        "rewards" => rewards
      }
    end
    
    def generate_rand_coefs(level_range, time_range, unit_types,
        unit_count_range, unit_hp_range)
      m_lvl = rand(level_range.first, level_range.last + 1)
      e_lvl = rand(level_range.first, level_range.last + 1)
      z_lvl = rand(level_range.first, level_range.last + 1)
      m_mult = rand(time_range.first, time_range.last + 1)
      e_mult = rand(time_range.first, time_range.last + 1)
      z_mult = rand(time_range.first, time_range.last + 1)
      unit_type = unit_types.blank? ? nil : unit_types.random_element
      unit_count = rand(unit_count_range.first, unit_count_range.last + 1)
      unit_hp = rand(unit_hp_range.first, unit_hp_range.last + 1)

      # Ensure we get _something_.
      if m_lvl == 0 && e_lvl == 0 && z_lvl == 0 && unit_count == 0
        generate_rand_coefs(level_range, time_range, unit_types,
          unit_count_range, unit_hp_range)
      else
        [m_lvl, e_lvl, z_lvl, m_mult, e_mult, z_mult, unit_type, unit_count,
          unit_hp]
      end
    end
    
    def generate_entry(key)
      config = CONFIG["tiles.exploration.rewards.#{key}.generator_config"]
      number = config['number']
      level_range = config['level']
      time_range = config['time']
      unit_types = config['unit_types']
      unit_count_range = config['unit_count']
      unit_hp_range = config['unit_hp']

      LOGGER.block("Generating exploration rewards for #{key}", 
        :level => :debug
      ) do
        %w{
          number level_range time_range unit_types unit_count_range 
          unit_hp_range
        }.each do |var|
          LOGGER.debug("%-20s: %s" % [var, eval(var).inspect])
        end

        number.times do
          m_lvl, e_lvl, z_lvl, m_mult, e_mult, z_mult, unit_type, 
            unit_count, unit_hp = generate_rand_coefs(
              level_range, time_range, unit_types,
              unit_count_range, unit_hp_range
            )

          add(key, item(
            Building::MetalExtractor.metal_rate(m_lvl) * m_mult,
            Building::CollectorT1.energy_rate(e_lvl) * e_mult,
            Building::ZetiumExtractor.zetium_rate(z_lvl) * z_mult,
            unit_type, unit_count, unit_hp
          ))
        end
      end
    end
    
    def generate
      # Generate presets
      generate_entry('win.with_units')
      generate_entry('win.without_units')
      generate_entry('lose.with_units')
      generate_entry('lose.without_units')
    end
  end
end