# Class to describe specific location point with bare minimum information
# needed to locate it.
# 
#    :type => Location::GALAXY || Location::SOLAR_SYSTEM ||
#      Location::SS_OBJECT,
#    :id => location_id,
#    :x => location_x,
#    :y => location_y
#    
# _location_x_ and _location_y_ will be point in the +Location+ or if
# +Location+ is +SsObject+ - point of where that planet is in a
# +SolarSystem+.
#
class LocationPoint
  include Location

  ATTRIBUTES = %w{id type x y}
  attr_reader *ATTRIBUTES.map(&:to_sym)

  CONVERTER = Proc.new { |value|
    case value
    when SsObject
      LocationPoint.new(value.id, Location::SS_OBJECT, nil, nil)
    when Unit
      LocationPoint.new(value.id, Location::UNIT, nil, nil)
    when Building
      LocationPoint.new(value.id, Location::BUILDING, nil, nil)
    else
      raise ArgumentError.new("Don't know how to convert #{value.inspect
        } to LocationPoint!")
    end
  }

  def self.attributes_mapping_for(side)
    ATTRIBUTES.map do |attribute|
      [:"#{side}_#{attribute}", attribute.to_sym]
    end
  end

  def initialize(id, type, x, y)
    raise ArgumentError.new(
      "id must be Fixnum, but was #{id.inspect}!"
    ) unless id.is_a?(Fixnum)
    raise ArgumentError.new(
      "type must be Fixnum, but was #{type.inspect}!"
    ) unless type.is_a?(Fixnum)

    @id, @type, @x, @y = id, type, x, y
  end

  # Return +Zone+ object for this +LocationPoint+.
  def zone
    raise NotImplementedError.new(
      "#zone doesn't make any sense for #{self}!"
    )
  end

  # Returns +Location+ object. See Location#find_by_attrs.
  def object
    Location.find_by_attrs(location_attrs)
  end

  # Converts self to +ClientLocation+.
  def to_client_location
    object.client_location
  end

  # See Location#location_attrs
  def location_attrs
    route_attrs("location_")
  end

  # See Location#route_attrs
  def route_attrs(prefix="")
    {
      "#{prefix}id".to_sym => @id,
      "#{prefix}type".to_sym => @type,
      "#{prefix}x".to_sym => @x,
      "#{prefix}y".to_sym => @y
    }
  end

  def to_s
    "<LP(t:#{@type}@#{@id}):#{@x},#{@y}>"
  end

  def ==(other)
    return false if other.nil? || ! other.respond_to?(:id) ||
      ! other.respond_to?(:type) || ! other.respond_to?(:x) ||
      ! other.respond_to?(:y)

    @id == other.id && @type == other.type && @x == other.x && @y == other.y
  end

  def as_json(options=nil)
    hash = {}
    ATTRIBUTES.each do |attribute|
      hash[attribute.to_sym] = send(attribute)
    end
    hash
  end
end