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

  COMPOSED_OF_GALAXY = [:galaxy_id, Location::GALAXY]
  COMPOSED_OF_SOLAR_SYSTEM = [:solar_system_id, Location::SOLAR_SYSTEM]
  COMPOSED_OF_SS_OBJECT = [:ss_object_id, Location::SS_OBJECT]
  COMPOSED_OF_BUILDING = [:building_id, Location::BUILDING]
  COMPOSED_OF_UNIT = [:unit_id, Location::UNIT]

  COMPOSED_OF_OPTIONS = [
    COMPOSED_OF_GALAXY, COMPOSED_OF_SOLAR_SYSTEM, COMPOSED_OF_SS_OBJECT,
    COMPOSED_OF_BUILDING, COMPOSED_OF_UNIT
  ]

  # Returns an option hash for composed_of.
  #
  # _prefix_ is DB side prefix of the column (e.g. :location or :source).
  # _parts_ are COMPOSED_OF_* constants which specify possible locations object
  # that options are being built for is created.
  def self.composed_of_options(prefix, *parts)
    klass = self
    {
      :class_name => to_s,
      :converter => lambda { |value|
        case value
        when SsObject
          klass.new(value.id, Location::SS_OBJECT, nil, nil)
        when Unit
          klass.new(value.id, Location::UNIT, nil, nil)
        when Building
          klass.new(value.id, Location::BUILDING, nil, nil)
        else
          raise ArgumentError.new("Don't know how to convert #{value.inspect
            } to #{klass}!")
        end
      },
      :mapping => [
        [:"#{prefix}_x", :x],
        [:"#{prefix}_y", :y],
      ] + parts.map { |attribute, location_type|
        [:"#{prefix}_#{attribute}", :"location_#{attribute}"]
      },
      :constructor => proc { |x, y, *args|
        id, type = nil
        parts.each_with_index do |(attribute, location_type), index|
          unless args[index].nil?
            id = args[index]
            type = location_type
            break
          end
        end

        if id.nil? || type.nil?
          index = 0
          params = parts.each_with_object({:x => x, :y => y, :type => type}) do
            |(attribute, location_type), hash|

            hash[attribute] = args[index]

            index += 1
          end

          raise ArgumentError,
            "Cannot construct #{klass} from #{params.inspect}"
        end

        klass.new(id, type, x, y)
      }
    }
  end

  def self.planet(planet_id)
    new(planet_id, SS_OBJECT, nil, nil)
  end

  def self.building(building_id)
    new(building_id, BUILDING, nil, nil)
  end

  def self.unit(unit_id)
    new(unit_id, UNIT, nil, nil)
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

  ### Readers for composed_of mappings ###

  def location_galaxy_id; @type == Location::GALAXY ? @id : nil; end
  def location_solar_system_id; @type == Location::SOLAR_SYSTEM ? @id : nil; end
  def location_ss_object_id; @type == Location::SS_OBJECT ? @id : nil; end
  def location_building_id; @type == Location::BUILDING ? @id : nil; end
  def location_unit_id; @type == Location::UNIT ? @id : nil; end

  # Returns DB column for current location type. E.g. if you're currently in a
  # galaxy, it will return :galaxy_id.
  def type_column
    COMPOSED_OF_OPTIONS.each do |attribute, type|
      return attribute.to_sym if @type == type
    end

    raise "Cannot determine type column from @type #{@type}!"
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

  # Compatibility method. Returns self.
  def location_point
    self
  end

  # Converts self to +ClientLocation+.
  def client_location
    ClientLocation.new(@id, @type, @x, @y)
  end

  # See Location#location_attrs
  def location_attrs
    route_attrs("location_")
  end

  # See Location#route_attrs
  def route_attrs(prefix="")
    base = {
      :"#{prefix}x" => @x,
      :"#{prefix}y" => @y
    }
    base.merge case @type
    when Location::GALAXY then {:"#{prefix}galaxy_id" => @id}
    when Location::SOLAR_SYSTEM then {:"#{prefix}solar_system_id" => @id}
    when Location::SS_OBJECT then {:"#{prefix}ss_object_id" => @id}
    when Location::UNIT then {:"#{prefix}unit_id" => @id}
    when Location::BUILDING then {:"#{prefix}building_id" => @id}
    end
  end

  def to_s
    "<LP t:#{@type.inspect}@#{@id.inspect},#{@x.inspect}:#{@y.inspect}>"
  end
  
  def inspect
    to_s
  end

  def ==(other); eql?(other); end

  def eql?(other)
    return false if other.nil? || ! other.respond_to?(:id) ||
      ! other.respond_to?(:type) || ! other.respond_to?(:x) ||
      ! other.respond_to?(:y)

    @id == other.id && @type == other.type && @x == other.x && @y == other.y
  end

  def hash
    @id.hash * 7 + @type.hash * 7 + @x.hash * 7 + @y.hash * 7
  end

  def as_json(options=nil)
    ATTRIBUTES.inject({}) do |hash, attribute|
      hash[attribute.to_s] = send(attribute).as_json
      hash
    end
  end
end