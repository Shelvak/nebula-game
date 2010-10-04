module Location
  GALAXY = 0
  SOLAR_SYSTEM = 1
  PLANET = 2
  UNIT = 3
  # Special type of location. location_id is not a building id, but rather
  # a planet id, and x, y references to this building x, y in the planet.
  BUILDING = 4

  # Returns distinct player ids that have units in given +LocationPoint+.
  # If the location is a +Planet+, existence of shooting buildings is also
  # checked.
  #
  def self.fighting_player_ids(location)
    player_ids = []
    player_ids.push Planet.find(location.id).player_id if \
      location.type == PLANET && \
      Building.shooting.where(:planet_id => location.id).count > 0
    player_ids | Unit.player_ids_in_location(location)
  end

  # Returns +Location+ object for given _attrs_ as obtained by
  # Location#location_attrs. It can be +GalaxyPoint+,
  # +SolarSystemPoint+, +Planet+, +Unit+ or +Building+.
  def self.find_by_attrs(attrs)
    case attrs[:location_type]
    when Location::GALAXY
      GalaxyPoint.new(attrs[:location_id], attrs[:location_x],
        attrs[:location_y])
    when Location::SOLAR_SYSTEM
      SolarSystemPoint.new(attrs[:location_id], attrs[:location_x],
        attrs[:location_y])
    when Location::PLANET
      Planet.find(attrs[:location_id])
    when Location::UNIT
      Unit.find(attrs[:location_id])
    when Location::BUILDING
      Building.find(:first, :conditions => {
          :planet_id => attrs[:location_id],
          :x => attrs[:location_x],
          :y => attrs[:location_y]
        })
    else
      raise ArgumentError.new("Unknown location type #{
        attrs[:location_type].inspect}!")
    end
  end

  # Check if given +Player+ can view given +Location+.
  def self.visible?(player, location)
    case location
    when LocationPoint
      case location.type
      when GALAXY
        FowGalaxyEntry.by_coords(location.x, location.y).for(
          player).count > 0
      when SOLAR_SYSTEM
        FowSsEntry.for(player).scoped_by_solar_system_id(
          location.id).count > 0
      end
    when Planet
      FowSsEntry.for(player).scoped_by_solar_system_id(
          location.solar_system_id).count > 0
    else
      raise ArgumentError.new("Unknown location type: #{location.inspect}")
    end
  end

  # Return +ClientLocation+.
  #
  def client_location
    raise NotImplementedError.new(
      "I should be implemented by a class that includes me!"
    )
  end

  # Should return +Hash+ with each key prefixed with _prefix_ than can be
  # used as a route parameter.
  #
  # This is used in UnitMover to generate route parameters.
  #
  # Given that the prefix is "" it should return:
  #
  # {
  #   :id => location_id,
  #   :type => Location::GALAXY || Location::SOLAR_SYSTEM ||
  #      Location::PLANET,
  #   :x => location_x,
  #   :y => location_y,
  # }
  #
  # If type is +GALAXY+ or +SOLAR_SYSTEM+ then _location_x_ and
  # _location_y_ should be coordinates in location. If type is +PLANET+
  # then _location_x_ should be position and _location_y_ should be angle.
  #
  def route_attrs(prefix="target")
    raise NotImplementedError.new(
      "I should be implemented by a class that includes me!"
    )
  end

  # Returns +Hash+ which can be used to set object location.
  #
  # {
  #   :location_id => location_id,
  #   :location_type => Location::GALAXY || Location::SOLAR_SYSTEM ||
  #      Location::PLANET,
  #   :location_x => location_x,
  #   :location_y => location_y,
  # }
  #
  # If type is +GALAXY+ or +SOLAR_SYSTEM+ then _location_x_ and
  # _location_y_ should be coordinates in location. If type is +PLANET+
  # then both is +nil+.
  #
  # _location_x_, _location_y_ represents _x_ and _y_ in +GALAXY+ type.
  # _location_x_, _location_y_ represents _angle_ and _position_ in
  # +SOLAR_SYSTEM+ type.
  #
  def location_attrs
    attrs = route_attrs("location_")

    case self
    when GalaxyPoint, SolarSystemPoint
      attrs
    when Planet
      {
        :location_id => attrs[:location_id],
        :location_type => attrs[:location_type],
        :location_x => nil,
        :location_y => nil
      }
    else
      raise NotImplementedError.new("I don't know how to handle #{
        self.class}!")
    end
  end
end
