# Class to describe location with all the information which is necessary
# for client to represent it.
# 
#    :type => Location::GALAXY || Location::SOLAR_SYSTEM ||
#      Location::SS_OBJECT,
#    :id => location_id,
#    :x => location_x,
#    :y => location_y,
#
#    :kind => kind | nil,
#
#    :name => name | nil,
#    :player => Player#minimal | nil
#    :terrain => terrain | nil,
#    :solar_system_id => solar_system_id | nil
#    
# See +LocationPoint+ for :type, :id, :x and :y explanations.
# 
# SolarSystem specific attributes (they should be nil for other locations):
#   _kind_ is +Fixnum+ of solar system kind.
#
# SsObject::Planet specific attributes:
#   _name_ should be nil unless Location is a +SsObject+. If so, use
#   _planet.name_ as _name_.
#
#   _terrain_ should be planet terrain.
#
#   _solar_system_id_ should be solar system id of planet parent 
#   +SolarSystem+.
#   
#   _player_ should be planet owner for that time.
#   nil or Player#as_json(:mode => :minimal)
#
class ClientLocation < LocationPoint
  SS_ATTRIBUTES = %w{kind}
  SS_OBJECT_ATTRIBUTES = %w{name terrain solar_system_id player}
  attr_reader *(SS_ATTRIBUTES + SS_OBJECT_ATTRIBUTES).map(&:to_sym)

  def initialize(id, type, x, y)
    super(id, type, x, y)

    case type
    when Location::GALAXY
      # Do nothing
    when Location::SOLAR_SYSTEM
      @kind = SolarSystem.where(:id => @id).select("kind").c_select_value

      raise ArgumentError.new("SolarSystem #{@id} does not exist!") \
        if @kind.nil?
    when Location::SS_OBJECT
      row = SsObject.
        select("name, terrain, solar_system_id, player_id, position, angle").
        where(:id => @id).
        c_select_one

      raise ArgumentError.new("SsObject #{@id} does not exist!") if row.nil?

      # Refer to +LocationPoint+ documentation.
      @x = row['position']
      @y = row['angle']

      @name = row['name']
      @terrain = row['terrain']
      @solar_system_id = row['solar_system_id']
      @player = Player.minimal(row['player_id'])
    else
      raise NotImplementedError.new("Unknown type #{@type}!")
    end
  end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && super(other)
  end

  def to_s
    super.sub("<LP", "<CL")
  end

  def hash
    super
  end

  def as_json(options=nil)
    hash = super
    (ATTRIBUTES + SS_ATTRIBUTES + SS_OBJECT_ATTRIBUTES).each do |attribute|
      hash[attribute.to_sym] = send(attribute)
    end
    hash
  end
end