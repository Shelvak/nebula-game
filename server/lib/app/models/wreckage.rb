# Wreckage gets left behind in galaxy/solar systems when units are
# destroyed there.
#
# Attributes sent to client are described in Wreckage#as_json.
#
# _galaxy_id_ attribute is needed because of FK CASCADE for galaxy.
#
class Wreckage < ActiveRecord::Base
  include Parts::WithLocking

  include Parts::Notifier
  include Parts::InLocation
  include Parts::Object
  include Parts::ByFowEntries

  composed_of :location, LocationPoint.composed_of_options(
    :location,
    LocationPoint::COMPOSED_OF_GALAXY,
    LocationPoint::COMPOSED_OF_SOLAR_SYSTEM
  )

  def to_s
    "<Wreckage(#{id})@#{location} m:#{metal} e:#{energy} z:#{zetium}"
  end

  # JSON representation
  #
  # Object with:
  # * id (Fixnum)
  # * location (LocationPoint#as_json)
  # * metal (Fixnum)
  # * energy (Fixnum)
  # * zetium (Fixnum)
  #
  def as_json(options=nil)
    {"id" => id, "location" => location.as_json(options),
      "metal" => metal, "energy" => energy, "zetium" => zetium}
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
    # Do nothing if there is not enough resources to create a wreckage.
    return if metal < 1 && energy < 1 && zetium < 1

    if location.is_a?(SsObject::Planet)
      location.metal += metal
      location.energy += energy
      location.zetium += zetium
      location.save!
      EventBroker.fire(location, EventBroker::CHANGED, 
        EventBroker::REASON_OWNER_PROP_CHANGE)
      location
    else
      wreckage = in_location(location).first || new(:location => location)

      wreckage.metal += metal.floor
      wreckage.energy += energy.floor
      wreckage.zetium += zetium.floor
      wreckage.save!

      wreckage
    end
  end

  # Override #update to destroy +Wreckage+ instead of saving it if it
  # is empty.
  def update(*)
    if metal == 0 && energy == 0 && zetium == 0
      destroy!
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

  def self.calculate_metal(metal); calculate_resource(metal); end
  def self.calculate_energy(energy); calculate_resource(energy); end
  def self.calculate_zetium(zetium); calculate_resource(zetium); end

  def self.calculate_resource(resource)
    resource * CONFIG.hashrand("combat.wreckage.range") / 100.0
  end
end