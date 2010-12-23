# Wreckage gets left behind in galaxy/solar systems when units are
# destroyed there.
#
# Attributes sent to client are described in Wreckage#as_json.
#
# _galaxy_id_ attribute is needed because of FK CASCADE for galaxy.
#
class Wreckage < ActiveRecord::Base
  include Parts::Notifier
  include Parts::InLocation
  include Parts::Object

  composed_of :location, :class_name => 'LocationPoint',
    :mapping => LocationPoint.attributes_mapping_for(:location),
    :converter => LocationPoint::CONVERTER

  # How much tolerance we should have when considering wreckage as depleted?
  #
  # If there is less or equal resource than this, then consider it depleted.
  REMOVAL_TOLERANCE = 0.5

  def to_s
    "<Wreckage(#{id})@#{location} m:#{metal} e:#{energy} z:#{zetium}"
  end

  # JSON representation
  #
  # Object with:
  # * location (LocationPoint#as_json)
  # * metal (Float)
  # * energy (Float)
  # * zetium (Float)
  #
  def as_json(options=nil)
    {:location => location.as_json(options),
      :metal => metal, :energy => energy, :zetium => zetium}
  end

  # Set galaxy id before creation.
  before_create do
    self.galaxy_id = case location
    when GalaxyPoint
      location.id
    when SolarSystemPoint
      location.object.galaxy_id
    else
      raise GameLogicError.new("Cannot create Wreckage in #{location}!")
    end
  end

  # Creates or updates +Wreckage+ in given _location_.
  #
  # Try finding existing +Wreckage+ in that _location_. If found - update it
  # and save.
  #
  # If not found - create it and save.
  #
  # If _location_ is +SsObject::Planet+ then instead of creating or updating
  # +Wreckage+ just increase resources in planet.
  #
  def self.add(location, metal, energy, zetium)
    raise ArgumentError.new("All resources must be positive! (given: m: #{
      metal}, e: #{energy}, z: #{zetium
      }) Perhaps you want to use #subtract?"
    ) if metal < 0 || energy < 0 || zetium < 0

    if location.is_a?(SsObject::Planet)
      location.metal += metal
      location.energy += energy
      location.zetium += zetium
      location.save!
      location
    else
      wreckage = in_location(location).first || new(:location => location)

      wreckage.metal += metal
      wreckage.energy += energy
      wreckage.zetium += zetium
      wreckage.save!

      wreckage
    end
  end

  # Updates +Wreckage+ in _location_.
  #
  # If resources are depleted - destroys it and returns nil. Else returns
  # updated +Wreckage+.
  #
  def self.subtract(location, metal, energy, zetium)
    raise ArgumentError.new("All resources must be positive! (given: m: #{
      metal}, e: #{energy}, z: #{zetium
      }) Perhaps you want to use #add?"
    ) if metal < 0 || energy < 0 || zetium < 0

    wreckage = in_location(location).first
    raise ActiveRecord::RecordNotFound.new(
      "Cannot find Wreckage in #{location}") if wreckage.nil?
    wreckage.metal -= metal
    wreckage.energy -= energy
    wreckage.zetium -= zetium
    
    if wreckage.metal <= REMOVAL_TOLERANCE && 
        wreckage.energy <= REMOVAL_TOLERANCE &&
        wreckage.zetium <= REMOVAL_TOLERANCE
      wreckage.destroy
      nil
    else
      wreckage.save!
      wreckage
    end
  end

  # Calculate how much resources is left from given _units_.
  #
  # Returns [metal, energy, zetium]
  def self.calculate(units)
    metal = energy = zetium = 0
    units.each do |unit|
      metal += unit.metal_cost * CONFIG.hashrand(
        "combat.wreckage.metal") / 100.0
      energy += unit.energy_cost * CONFIG.hashrand(
        "combat.wreckage.energy") / 100.0
      zetium += unit.zetium_cost * CONFIG.hashrand(
        "combat.wreckage.zetium") / 100.0
    end

    [metal, energy, zetium]
  end
end