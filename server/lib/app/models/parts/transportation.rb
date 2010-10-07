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
      raise GameLogicError.new(
        "You did not give any units to load!"
      ) if units.blank?
      
      taken_volume = self.class.calculate_volume(units)

      raise GameLogicError.new(
        "Not enough storage (#{stored}/#{storage
          }) to load all requested units (volume #{taken_volume})!"
      ) if taken_volume > (storage - stored)

      transaction do
        self.stored += taken_volume
        save!
        EventBroker.fire(self, EventBroker::CHANGED)

        Unit.update_location_all(location_point, {:id => units.map(&:id)})
        EventBroker.fire(units, EventBroker::CHANGED,
          EventBroker::REASON_LOADED)
      end
    end

    # Unloads units in contained in this +Unit+ into _planet_.
    def unload(units, planet)
      raise GameLogicError.new(
        "You did not give any units to unload!"
      ) if units.blank?

      transaction do
        self.stored -= self.class.calculate_volume(units)
        save!
        EventBroker.fire(self, EventBroker::CHANGED)

        Unit.update_location_all(
          planet.location_point, {:id => units.map(&:id)}
        )
        EventBroker.fire(units, EventBroker::CHANGED,
          EventBroker::REASON_UNLOADED)
      end
    end
  end

  module ClassMethods
    # Returns +Unit+ storage for _level_.
    def storage; property('storage', 0); end

    # How much storage does this +Unit+ take.
    def volume; property('volume'); end

    # Calculates total volume of _units_.
    def calculate_volume(units)
      units.reduce(0) do |sum, unit|
        volume = unit.volume
        raise GameLogicError.new("#{unit} does not have volume!") \
          if volume.nil?

        sum + volume
      end
    end
  end
end
