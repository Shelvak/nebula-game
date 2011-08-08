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
class ExplorationRewardsInitializer
  def self.initialize
    return if @initialized
    
    starting_point = 100_000.0
    # Multiplier to tweak probabilities
    metal_mult = 4
    energy_mult = 2
    zetium_mult = 30
    unit_mult = 4

    add = lambda do |side, item|
      CONFIG["tiles.exploration.rewards.#{side}"] ||= []
      CONFIG["tiles.exploration.rewards.#{side}"].push item
    end

    calculate_weight = lambda do |metal, energy, zetium|
      total = metal * metal_mult + energy * energy_mult + zetium * zetium_mult
      total == 0 ? 0 : (starting_point / total).round
    end

    item = lambda do |metal, energy, zetium, unit_type, unit_count, unit_hp|
      weight = 0
      rewards = []

      if unit_count > 0
        klass = "Unit::#{unit_type.camelcase}".constantize
        hp_f = unit_hp.to_f / 100
        unit_metal = klass.metal_cost(1) * unit_count * unit_mult * hp_f
        unit_energy = klass.energy_cost(1) * unit_count * unit_mult * hp_f
        unit_zetium = klass.zetium_cost(1) * unit_count * unit_mult * hp_f
        weight += calculate_weight.call(unit_metal, unit_energy, unit_zetium)
        rewards.push("kind" => Rewards::UNITS, "type" => unit_type,
          "count" => unit_count, "hp" => unit_hp)
      end

      rewards.push("kind" => Rewards::METAL, "count" => metal) if metal > 0
      rewards.push("kind" => Rewards::ENERGY, "count" => energy) if energy > 0
      rewards.push("kind" => Rewards::ZETIUM, "count" => zetium) if zetium > 0
      weight += calculate_weight.call(metal, energy, zetium)

      raise \
        ("Rewards are empty! metal: %3.4f, energy: %3.4f, " +
        "zetium: %3.4f, unit_type: %s, unit_count: %d, unit_hp: %d") % [
          metal, energy, zetium, unit_type, unit_count, unit_hp
        ] if rewards.blank?

      raise "Weight cannot be 0 for #{rewards.inspect}!" if weight < 1
      {
        "weight" => weight,
        "rewards" => rewards
      }
    end

    generate_rand_coefs = lambda do |level_range, time_range, unit_types,
        unit_count_range, unit_hp_range|
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
        generate_rand_coefs.call(level_range, time_range, unit_types,
          unit_count_range, unit_hp_range)
      else
        [m_lvl, e_lvl, z_lvl, m_mult, e_mult, z_mult, unit_type, unit_count,
          unit_hp]
      end
    end

    generate = lambda do |side|
      config = CONFIG["tiles.exploration.rewards.#{side}.generator_config"]
      number = config['number']
      level_range = config['level']
      time_range = config['time']
      unit_types = config['unit_types']
      unit_count_range = config['unit_count']
      unit_hp_range = config['unit_hp']

      LOGGER.block("Generating exploration rewards for #{side}", 
        :level => :debug
      ) do
        %w{
          number level_range time_range unit_types unit_count_range 
          unit_hp_range
        }.each do |var|
          LOGGER.debug("%-20s: %s" % [var, eval(var).inspect])
        end

        number.times do
          m_lvl, e_lvl, z_lvl, m_mult, e_mult, z_mult, unit_type, unit_count,
            unit_hp = generate_rand_coefs.call(
              level_range, time_range, unit_types,
              unit_count_range, unit_hp_range
            )

          add.call(side, item.call(
            Building::MetalExtractor.metal_rate(m_lvl) * m_mult,
            Building::CollectorT1.energy_rate(e_lvl) * e_mult,
            Building::ZetiumExtractor.zetium_rate(z_lvl) * z_mult,
            unit_type, unit_count, unit_hp
          ))
        end
      end
    end

    # Generate presets
    generate.call('win.with_units')
    generate.call('win.without_units')
    generate.call('lose.with_units')
    generate.call('lose.without_units')
    
    @initialized = true
  end
end