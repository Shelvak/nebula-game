# Builds units from various definitions. Returns arrays of units.
class UnitBuilder
  # Builds from: [ [count_from, count_to, type, flank], ... ]
  #
  # _count_from_ and _count_to_ can be formulas with _counter_ and _spot_
  # variables.
  #
  # count numbers are inclusive.
  #
  def self.from_random_ranges(definition, location, player_id, counter, spot)
    units = []
    definition.each do |count_from, count_to, type, flank|
      params = {'counter' => counter, 'spot' => spot}
      count_from = CONFIG.safe_eval(count_from, params).to_i
      count_to = CONFIG.safe_eval(count_to, params).to_i

      count = rand(count_from, count_to + 1)
      klass = "Unit::#{type}".constantize
      count.times do
        unit = klass.new(
          location: location,
          player_id: player_id,
          level: 1,
          flank: flank
        )
        units.push unit
      end
    end
    units
  end
end