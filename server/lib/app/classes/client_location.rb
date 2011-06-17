# Class to describe location with all the information which is necessary
# for client to represent it.
# 
#    :type => Location::GALAXY || Location::SOLAR_SYSTEM ||
#      Location::SS_OBJECT,
#    :id => location_id,
#    :x => location_x,
#    :y => location_y,
#    :name => name,
#    :kind => kind,
#    :terrain => terrain,
#    :solar_system_id => solar_system_id
#    
# See +LocationPoint+ for :type, :id, :x and :y explanations.
# 
# SolarSystem specific attributes (they should be nil for other locations):
#   _kind_ is +Fixnum+ of solar system kind.
#
# SsObject specific attributes:
#   _name_ should be nil unless Location is a +SsObject+. If so, use
#   _planet.name_ as _name_.
#
#   _terrain_ should be planet terrain.
#
#   _solar_system_id_ should be solar system id of planet parent 
#   +SolarSystem+.
#
class ClientLocation < LocationPoint
  ATTRIBUTES = %w{name kind terrain solar_system_id}
  attr_reader *ATTRIBUTES.map(&:to_sym)

  def self.attributes_mapping_for(side)
    super(side) + ATTRIBUTES.map do |attribute|
      [:"#{side}_#{attribute}", attribute.to_sym]
    end
  end

  def initialize(id, type, x, y, name, kind, terrain, solar_system_id)
    super(id, type, x, y)
    @name, @kind, @terrain, @solar_system_id = \
      name, kind, terrain, solar_system_id
  end

  def eql?(other)
    return false if other.nil? or ! other.is_a?(ClientLocation)

    # We skip name because names of planets can be changed by players
    super(other) &&
      @kind == other.kind &&
      @terrain == other.terrain &&
      @solar_system_id == other.solar_system_id
  end

  def hash
    super + @kind.hash * 7 + @terrain.hash * 7 + @solar_system_id.hash * 7
  end

  def as_json(options=nil)
    hash = super
    ATTRIBUTES.each do |attribute|
      hash[attribute.to_sym] = send(attribute)
    end
    hash
  end
end