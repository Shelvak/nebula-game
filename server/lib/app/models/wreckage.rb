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
  REMOVAL_TOLERANCE = 1

  def to_s
    "<Wreckage(#{id})@#{location} m:#{metal} e:#{energy} z:#{zetium}"
  end

  # JSON representation
  #
  # Object with:
  # * id (Fixnum)
  # * location (LocationPoint#as_json)
  # * metal (Float)
  # * energy (Float)
  # * zetium (Float)
  #
  def as_json(options=nil)
    {"id" => id, "location" => location.as_json(options),
      "metal" => metal, "energy" => energy, "zetium" => zetium}
  end

  # Set galaxy id before creation.
  before_create do
    self.galaxy_id = case location
    when LocationPoint
      case location.type
      when Location::GALAXY
        location.id
      when Location::SOLAR_SYSTEM
        # Convert +LocationPoint+ to +SolarSystemPoint+ and return
        # #galaxy_id
        location.object.galaxy_id
      else
        raise GameLogicError.new("Cannot create Wreckage in #{location}!")
      end
    else
      raise ArgumentError.new("Unknown location class: #{location.inspect}")
    end

    true
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
      EventBroker.fire(location, EventBroker::CHANGED)
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

  # Override #update to destroy +Wreckage+ instead of saving it if it
  # crosses REMOVAL_TOLERANCE.
  def update(*)
    if metal < REMOVAL_TOLERANCE &&
        energy < REMOVAL_TOLERANCE &&
        zetium < REMOVAL_TOLERANCE
      destroy
      true
    else
      super
    end
  end

  # Calculate how much resources is left from given _units_.
  #
  # Returns [metal, energy, zetium]
  def self.calculate(participants)
    metal = energy = zetium = 0
    participants.each do |participant|
      metal += calculate_metal(participant.metal_cost)
      energy += calculate_energy(participant.energy_cost)
      zetium += calculate_zetium(participant.zetium_cost)

      # Add stored things as wreckage too.
      if participant.is_a?(Unit) && participant.stored > 0
        units_metal, units_energy, units_zetium = \
          calculate(participant.units)
        metal += units_metal + participant.metal
        energy += units_energy + participant.energy
        zetium += units_zetium + participant.zetium
      end
    end

    [metal, energy, zetium]
  end

  def self.calculate_metal(metal); calculate_resource("metal", metal); end
  def self.calculate_energy(energy); calculate_resource("energy", energy); end
  def self.calculate_zetium(zetium); calculate_resource("zetium", zetium); end

  def self.calculate_resource(name, resource)
    resource * CONFIG.hashrand("combat.wreckage.#{name}") / 100.0
  end

  # Returns wreckages visible by _fow_entries_ in +Galaxy+.
  def self.by_fow_entries(fow_entries)
    find_by_sql(
      "SELECT * FROM `#{table_name}` WHERE #{
        FowGalaxyEntry.conditions(fow_entries)}")
  end
end