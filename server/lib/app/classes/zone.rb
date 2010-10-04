# Zone is an object which holds many location points. For example both
# +Galaxy+ and +SolarSystem+ are zones, because they include many
# +LocationPoint+.
#
module Zone
  def self.resolve_type(object)
    case object
    when Galaxy
      type = Location::GALAXY
    when SolarSystem
      type = Location::SOLAR_SYSTEM
    else
      raise ArgumentError.new("Unknown zone type #{self.class.to_s}!")
    end

    type
  end

  # Return if these two locations are in different zones or not.
  def self.different?(old, new)
    if old.type == new.type
      old.id != new.id
    else
      true
    end
  end

  # Returns +Zone+ attributes. These attributes can be used in finders to
  # find units, route hops or other objects contained in that zone.
  def zone_attrs
    {
      :location_id => id,
      :location_type => Zone.resolve_type(self)
    }
  end

  def include?(location_point)
    if location_point.is_a?(LocationPoint)
      location_point.id == id &&
        location_point.type == Zone.resolve_type(self)
    else
      false
    end
  end
end
