module Location
  GALAXY = 0
  SOLAR_SYSTEM = 1
  SS_OBJECT = 2
  UNIT = 3
  BUILDING = 4

  # Returns distinct player ids that have units in given +LocationPoint+.
  # If the location is a +SsObject+, existence of shooting non-upgrading
  # buildings is also checked.
  #
  def self.combat_player_ids(location_point)
    typesig binding, LocationPoint
    
    player_ids = []
    if location_point.type == SS_OBJECT
      ss_object = location_point.object
      if ss_object.is_a?(SsObject::Planet)
        # Add non NPC players to combat or NPC players if they have combat
        # buildings.
        if ! ss_object.player_id.nil? || without_locking {
          ss_object.buildings.combat.where(:state => Building::STATE_ACTIVE).
            size != 0
        }
          player_ids.push ss_object.player_id
        end
      end
    end
    player_ids | Unit.player_ids_in_location(location_point, true)
  end

  def self.find_by_type_hash(attrs)
    typesig binding, Hash

    id = attrs[:location_id]

    case attrs[:location_type]
    when Location::GALAXY
      GalaxyPoint.new(id, attrs[:location_x], attrs[:location_y])
    when Location::SOLAR_SYSTEM
      SolarSystemPoint.new(id, attrs[:location_x], attrs[:location_y])
    when Location::SS_OBJECT
      SsObject.find(id)
    when Location::UNIT
      Unit.find(id)
    when Location::BUILDING
      Building.find(id)
    else
      raise ArgumentError, "Cannot find location from type #{type}!"
    end
  end

  # Returns +Location+ object for given _attrs_ as obtained by
  # Location#location_attrs. It can be +GalaxyPoint+,
  # +SolarSystemPoint+, +SsObject+, +Unit+ or +Building+.
  def self.find_by_attrs(attrs)
    typesig binding, Hash

    id, type = id_and_type_from_row(attrs)
    find_by_type_hash(
      :location_id => id, :location_type => type,
      :location_x => attrs[:location_x], :location_y => attrs[:location_y]
    )
  end

  # Returns [id, type] from row.
  def self.id_and_type_from_row(row, prefix="location_")
    typesig binding, Hash

    row = row.symbolize_keys

    if ! row[:"#{prefix}galaxy_id"].nil?
      [row[:"#{prefix}galaxy_id"], Location::GALAXY]
    elsif ! row[:"#{prefix}solar_system_id"].nil?
      [row[:"#{prefix}solar_system_id"], Location::SOLAR_SYSTEM]
    elsif ! row[:"#{prefix}ss_object_id"].nil?
      [row[:"#{prefix}ss_object_id"], Location::SS_OBJECT]
    elsif ! row[:"#{prefix}unit_id"].nil?
      [row[:"#{prefix}unit_id"], Location::UNIT]
    elsif ! row[:"#{prefix}building_id"].nil?
      [row[:"#{prefix}building_id"], Location::BUILDING]
    else
      raise ArgumentError, "Cannot find location from #{row.inspect}!"
    end
  end

  # Check if given +Player+ can view given +Location+.
  def self.visible?(player, location)
    check_in_ss = lambda do |ss_id|
      if ss_id == Galaxy.battleground_id(player.galaxy_id)
        SolarSystem.sees_wormhole?(player)
      else
        begin
          SolarSystem.find_if_viewable_for(ss_id, player)
          true
        rescue ActiveRecord::RecordNotFound
          false
        end
      end
    end

    case location
    when LocationPoint
      case location.type
      when GALAXY
        FowGalaxyEntry.by_coords(location.x, location.y).for(player).count > 0
      when SOLAR_SYSTEM
        check_in_ss.call(location.id)
      end
    when SsObject
      check_in_ss.call(location.solar_system_id)
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
  #      Location::SS_OBJECT,
  #   :x => location_x,
  #   :y => location_y,
  # }
  #
  # If type is +GALAXY+ or +SOLAR_SYSTEM+ then _location_x_ and
  # _location_y_ should be coordinates in location. If type is +SS_OBJECT+
  # then _location_x_ should be position and _location_y_ should be angle.
  #
  def route_attrs(prefix="target")
    raise NotImplementedError.new(
      "I should be implemented by a class that includes me!"
    )
  end

  # Returns +Hash+ which can be used to query objects by location.
  #
  # {
  #   :location_#{type}_id => Fixnum,
  #   :location_x => location_x,
  #   :location_y => location_y,
  # }
  #
  # If type is +GALAXY+ or +SOLAR_SYSTEM+ then _location_x_ and
  # _location_y_ should be coordinates in location. If type is +SS_OBJECT+
  # then both is +nil+.
  #
  # _location_x_, _location_y_ represents _x_ and _y_ in +GALAXY+ type.
  # _location_x_, _location_y_ represents _angle_ and _position_ in
  # +SOLAR_SYSTEM+ type.
  #
  def location_attrs
    attrs = route_attrs(:location_)

    case self
    when GalaxyPoint, SolarSystemPoint
      attrs
    when SsObject
      attrs.except(:location_x, :location_y)
    else
      raise NotImplementedError.new("I don't know how to handle #{
        self.class}!")
    end
  end
end
