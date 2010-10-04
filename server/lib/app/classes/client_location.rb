# Class to describe location with all the information which is necessary
# for client to represent it.
# 
#    :type => Location::GALAXY || Location::SOLAR_SYSTEM ||
#      Location::PLANET,
#    :id => location_id,
#    :x => location_x,
#    :y => location_y,
#    :name => name,
#    :variation => variation,
#    :solar_system_id => solar_system_id
#    
# See +LocationPoint+ for :type, :id, :x and :y explanations.
#
# Planet specific attributes (they should be nil for other locations):
#   _name_ should be nil unless Location is a +Planet+. If so, use
#   _planet.name_ as _name_.
#
#   _variation_ should be planet variation.
#
#   _solar_system_id_ should be solar system id of planet parent 
#   +SolarSystem+.
#
class ClientLocation < LocationPoint
  ATTRIBUTES = %w{name variation solar_system_id}
  attr_reader *ATTRIBUTES.map(&:to_sym)

  def self.attributes_mapping_for(side)
    super(side) + ATTRIBUTES.map do |attribute|
      [:"#{side}_#{attribute}", attribute.to_sym]
    end
  end

  def initialize(id, type, x, y, name, variation, solar_system_id)
    super(id, type, x, y)
    @name, @variation, @solar_system_id = name, variation, solar_system_id
  end

  def ==(other)
    return false if other.nil? or ! other.is_a?(ClientLocation)

    # We skip name because names of planets can be changed by players
    super(other) &&
      @variation == other.variation &&
      @solar_system_id == other.solar_system_id
  end

  def as_json(options=nil)
    hash = super
    ATTRIBUTES.each do |attribute|
      hash[attribute.to_sym] = send(attribute)
    end
    hash
  end
end