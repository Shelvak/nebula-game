# Builds units from various definitions. Returns arrays of units.
class UnitBuilder
  # Builds from: [ [count_from, count_to, type, flank], ... ]
  #
  # count numbers are inclusive.
  #
  def self.from_random_ranges(definition, galaxy_id, location, player_id)
    units = []
    definition.each do |count_from, count_to, type, flank|
      count = rand(count_from, count_to + 1)
      klass = "Unit::#{type}".constantize
      count.times do
        unit = klass.new(
          :galaxy_id => galaxy_id,
          :location => location,
          :player_id => player_id,
          :level => 1,
          :flank => flank
        )
        units.push unit
      end
    end
    units
  end
end