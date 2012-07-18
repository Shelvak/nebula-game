# Methods for dealing with transportation of units.
module Parts::Transportation
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods

    receiver.send :has_many, :units, :foreign_key => :location_unit_id

    receiver.send :after_destroy,
        :if => lambda { |r| r.location.type == Location::UNIT } do
      transporter = location.object
      transporter.stored -= volume
      transporter.save!
      EventBroker.fire(transporter, EventBroker::CHANGED)
    end
  end

  module InstanceMethods
    # Is this +Unit+ a transporter?
    def transporter?; self.class.transporter?; end

    # Returns +Unit+ storage.
    def storage
      storage = self.class.storage(level)
      # Whoa, man, this is sooo suboptimal, hitting DB each time, but I'm still
      # a bit sick and have no better thoughts - arturaz, 2011-10-20
      technologies = without_locking do
        TechTracker.query_active(player.id, TechTracker::STORAGE).all
      end
      storage_mods = TechModApplier.apply(technologies, TechTracker::STORAGE)
      (storage * (1 + (storage_mods[self.class.to_s] || 0))).round
    end

    # How much storage does this +Unit+ take.
    def volume; self.class.volume; end

    # Loads given _units_ into this +Unit+. Raises error if any of the
    # models does not have #volume or we are out of storage in this +Unit+.
    #
    # All loaded units must be in same location as transporter.
    def load(units)
      raise GameLogicError.new(
        "You did not give any units to load!"
      ) if units.blank?

      transporter_location = location
      units.each do |unit|
        raise GameLogicError.new(
          "Unit #{unit} must be in same location as #{self}!"
        ) unless unit.location == transporter_location

        raise GameLogicError.new(
          "Cannot load unit #{unit} that is still upgrading!"
        ) if unit.upgrading?
      end
      
      taken_volume = self.class.calculate_volume(units)

      raise GameLogicError.new(
        "Not enough storage (#{stored}/#{storage
          }) to load all requested units into #{self} (volume #{taken_volume})!"
      ) if taken_volume > (storage - stored)

      self.stored += taken_volume
      save!

      update_transporter_units(units, location_point)
    end

    # Unloads units in contained in this +Unit+ into _planet_.
    def unload(units, planet)
      raise GameLogicError.new(
        "You did not give any units to unload!"
      ) if units.blank?

      transporter_location = location_point
      units.each do |unit|
        raise GameLogicError.new(
          "Unit #{unit} must be in #{self}!"
        ) unless unit.location == transporter_location
        raise GameLogicError.new(
          "Unit #{unit} must not be hidden!"
        ) if unit.hidden?
      end

      self.stored -= self.class.calculate_volume(units)
      save!

      update_transporter_units(units, planet.location_point)
    end

    # Loads/unloads _metal_, _energy_ and _zetium_ from _source_ to/from
    # this transporter. Increases/decreases _stored_ on transporter.
    #
    # Resources are taken from current location. If transporter is in space
    # it will take them from wreckage. If unloading - wreckage will either
    # be created or updated.
    def transfer_resources!(metal, energy, zetium)
      raise GameLogicError.new(
        "You're not trying to do anything! All resources are 0!") \
        if metal == 0 && energy == 0 && zetium == 0

      # Check where we are.
      location = self.location
      # If we are in space we need wreckage.
      if location.type == Location::GALAXY ||
          location.type == Location::SOLAR_SYSTEM
        location = Wreckage.in_location(location).first ||
          Wreckage.new(:location => location)
      elsif location.type == Location::SS_OBJECT
        # Fetch planet otherwise.
        location = location.object
      else
        # Whoa?
        raise "We didn't expect that transporter would be in #{location}!"
      end

      will_unload = false
      resources = [[:metal, metal], [:energy, energy], [:zetium, zetium]]

      resources.each do |resource, value|
        if value < 0
          # Check if we're not trying to unload more resources than we have.
          current = send(resource)
          raise GameLogicError.new(
            "Trying to unload more #{resource} (#{value}) than we have (#{
              current})!") if value.abs > current
          will_unload = true
        elsif value > 0
          # Check if we're not trying to load more resources than we have.
          current = location.send(resource)
          raise GameLogicError.new(
            "Trying to load more #{resource} (#{value}) than we have (#{
              current})!") if value > current
        end
      end

      # Check if we have enough storage to load resources.
      volume = Resources.total_volume_diff(
        self.metal, self.metal + metal,
        self.energy, self.energy + energy,
        self.zetium, self.zetium + zetium
      )
      raise GameLogicError.new(
        "Not enough free storage (#{volume} needed) to load m:#{
        metal}, e:#{energy}, z:#{zetium}!"
      ) if storage - stored < volume

      self.stored += volume

      # Actually transfer the resources.
      resources.each do |resource, amount|
        location.send("#{resource}=", location.send(resource) - amount)
        send("#{resource}=", send(resource) + amount)
      end

      save!
      # Do not save it is a new wreckage and we will unload.
      if (location.new_record? && will_unload) || ! location.new_record?
        location.save!
      end
      EventBroker.fire(self, EventBroker::CHANGED)
      # Only fire changed for those which does not notify themselves.
      EventBroker.fire(
        location, EventBroker::CHANGED,
        # Dispatch global update if planet is owner by NPC.
        location.player_id.nil? ? nil : EventBroker::REASON_OWNER_PROP_CHANGE
      ) if location.is_a?(SsObject::Planet)
    end

    def update_transporter_units(units, location)
      Unit.where(:id => units.map(&:id)).update_all \
        "#{Unit.set_flag_sql(:hidden, false)}, #{
          Unit.update_location_sql(location)}"
      
      # Update unit locations and hidden flags before dispatching it to client.
      units.each do |unit|
        unit.location = location
        unit.hidden = false
      end

      EventBroker.fire([self] + units, EventBroker::CHANGED,
        EventBroker::REASON_TRANSPORTATION)
    end
  end

  module ClassMethods
    # Is this +Unit+ is a transporter?
    def transporter?; ! property('storage').nil?; end

    # Returns +Unit+ storage.
    def storage(level); evalproperty('storage', 0, 'level' => level).round; end

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
