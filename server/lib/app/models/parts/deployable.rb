# Extends units with #deploy functionality.
module Parts::Deployable
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    # Deploys +Unit+ to +SsObject+ in x, y. Starts a building in that place
    # and destroys source unit.
    #
    def deploy(planet, x, y)
      raise GameLogicError.new("Unit #{self.inspect} is not deployable!") \
        unless deployable?

      transaction do
        building = deploys_to_class.new(:planet => planet, :x => x, :y => y)
        building.level = 0
        building.construction_mod = 0
        building.skip_resources = true
        building.skip_validate_technologies = true
        building.upgrade!
        EventBroker.fire(building, EventBroker::CREATED)

        # Destroy unit, it has been consumed.
        destroy
        EventBroker.fire(self, EventBroker::DESTROYED)
      end
    end

    # Is this unit deployable?
    def deployable?
      self.class.deployable?(type)
    end

    # Return +Class+ for +Building+ to which this +Unit+ deploys.
    def deploys_to_class
      self.class.deploys_to_class(type)
    end
  end

  module ClassMethods
    # Is given _type_ deployable?
    def deployable?(type)
      CONFIG["units.#{type.underscore}.deploys_to"].present?
    end

    # Return +Class+ for +Building+ to which this _type_ deploys.
    def deploys_to_class(type)
      (
        "Building::%s" % CONFIG["units.#{type.underscore}.deploys_to"]
      ).constantize
    end
  end
end
