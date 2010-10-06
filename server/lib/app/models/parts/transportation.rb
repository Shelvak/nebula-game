# Methods for dealing with transportation of units.
module Parts::Transportation
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    # Returns +Unit+ storage.
    def storage; self.class.storage; end

    # How much storage does this +Unit+ take.
    def volume; self.class.volume; end

    # Loads given _units_ into this +Unit+. Raises error if any of the
    # models does not have #volume or we are out of storage in this +Unit+.
    def load(units)
      taken_volume = units.reduce(0) do |sum, unit|
        volume = unit.volume
        raise GameLogicError.new(
          "Trying to load #{unit} which doesn't have volume!"
        ) if volume.nil?

        sum + volume
      end

      raise GameLogicError.new(
        "Not enough storage (#{stored}/#{storage
          }) to load all requested units (volume #{taken_volume})!"
      ) if taken_volume > (storage - stored)

      transaction do
        self.stored += taken_volume
        save!

        Unit.update_location_all(
          UnitLocation.new(id),
          {:id => units.map(&:id)}
        )
        EventBroker.fire(units, EventBroker::CHANGED)
      end
    end

    # Unloads units in contained in this +Unit+ into _planet_.
    def unload(units, planet)
      transaction do
        taken_volume = units.reduce(0) { |sum, unit| sum + unit.volume }
        self.stored -= taken_volume
        save!

        Unit.update_location_all(
          planet.location_point, ["id IN (?)", units.map(&:id)]
        )
        EventBroker.fire(units, EventBroker::CHANGED)
      end
    end
  end

  module ClassMethods
    # Returns +Unit+ storage for _level_.
    def storage; property('storage', 0); end

    # How much storage does this +Unit+ take.
    def volume; property('volume'); end
  end
end
