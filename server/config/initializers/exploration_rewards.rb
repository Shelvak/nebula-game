# This file generates:
# * CONFIG[tiles.exploration.rewards.win]
# * CONFIG[tiles.exploration.rewards.lose]
#
# And fills it with random rewards. Bigger reward means less chance of
# getting it. Configuration for this generator is done in sections/tiles.yml
# file.

# Wrap it up in anonymous method.
lambda do
  starting_point = 100_000.0
  # Multiplier to tweak probabilities
  metal_mult = 4
  energy_mult = 2
  zetium_mult = 30

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
      unit_metal = klass.metal_cost(1) * unit_count
      unit_energy = klass.energy_cost(1) * unit_count
      unit_zetium = klass.zetium_cost(1) * unit_count
      weight += calculate_weight.call(unit_metal, unit_energy, unit_zetium)
      rewards.push("kind" => Rewards::UNITS, "type" => unit_type,
        "count" => unit_count, "hp" => unit_hp)
    end

    rewards.push("kind" => Rewards::METAL, "count" => metal) if metal > 0
    rewards.push("kind" => Rewards::ENERGY, "count" => energy) if energy > 0
    rewards.push("kind" => Rewards::ZETIUM, "count" => zetium) if zetium > 0
    weight += calculate_weight.call(metal, energy, zetium)

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
    unit_type = unit_types.random_element
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

  # seed the random
  srand(12785412578147812)

  # Generate presets
  generate.call('win')
  generate.call('lose')

  # reset random to random seed
  srand
end.call