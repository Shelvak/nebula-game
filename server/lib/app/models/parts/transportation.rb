# Methods for dealing with transportation of units.
module Parts::Transportation
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods

    receiver.send :has_many, :units, :finder_sql => "SELECT * FROM `#{
      receiver.table_name}` WHERE `location_id`=\#{id} AND `location_type`=#{
      Location::UNIT}"
    receiver.send :after_destroy do
      # Unit instead of self.class because it would use subclass like
      # Unit::Mule
      Unit.delete_all ["location_type=? AND location_id=?",
        Location::UNIT, id]
    end

    receiver.send :after_destroy,
        :if => lambda { |r| r.location.type == Location::UNIT } do
      transporter = location.object
      transporter.stored -= volume
      transporter.save!
      EventBroker.fire(transporter, EventBroker::CHANGED)
    end
  end

  module InstanceMethods
    # Returns +Unit+ storage.
    def storage; self.class.storage; end

    # How much storage does this +Unit+ take.
    def volume; self.class.volume; end

    # How much storage does this +Unit+ unload per tick in combat.
    def unload_per_tick(level=nil)
      self.class.unload_per_tick(level || self.level)
    end

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
      end
      
      taken_volume = self.class.calculate_volume(units)

      raise GameLogicError.new(
        "Not enough storage (#{stored}/#{storage
          }) to load all requested units (volume #{taken_volume})!"
      ) if taken_volume > (storage - stored)

      transaction do
        self.stored += taken_volume
        save!

        update_transporter_units(units, location_point)
      end
    end

    # Loads _metal_, _energy_ and _zetium_ from _source_ to this
    # transporter. Increases _stored_ on transporter.
    #
    # _source_ can be either +SsObject::Planet+ or +Wreckage+
    def load_resources!(source, metal, energy, zetium)
      raise GameLogicError.new(
        "Cannot load negative resources! m: #{metal}, e: #{energy}, z: #{
        zetium}"
      ) if metal < 0 || energy < 0 || zetium < 0
      raise GameLogicError.new(
        "Transporter must be in #{source} to be able to load resources!"
      ) if location != source.location

      volume = self.class.calculate_resources_volume(metal, energy, zetium)
      raise GameLogicError.new(
        "Not enough free storage (#{volume} needed) to load m:#{
        metal}, e:#{energy}, z:#{zetium}!"
      ) if storage - stored < volume

      [[:metal, metal], [:energy, energy], [:zetium, zetium]].each do
        |resource, amount|
        source_amount = source.send(resource)
        raise GameLogicError.new(
          "Not enough #{resource} (#{amount} needed) on #{source}!"
        ) if source_amount < amount

        source.send("#{resource}=", source_amount - amount)
        send("#{resource}=", send(resource) + amount)
      end
        
      self.stored += volume

      transaction do
        save!
        source.save!
        EventBroker.fire(self, EventBroker::CHANGED)
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

        update_transporter_units(units, planet.location_point)
      end
    end

    # Unloads _metal_, _energy_ and _zetium_ to _target_ from this
    # transporter. Decreases _stored_ on transporter.
    #
    # Transporter must be either in _planet_ or in space to be able to
    # unload.
    #
    # _target_ must be either +SsObject::Planet+ or +LocationPoint+
    #
    def unload_resources!(target, metal, energy, zetium)
      raise GameLogicError.new(
        "Cannot unload negative resources! m: #{metal}, e: #{energy}, z: #{
        zetium}"
      ) if metal < 0 || energy < 0 || zetium < 0
      raise GameLogicError.new(
        "Trying to unload more resources than we have! " +
          "m: #{metal}/has #{self.metal}, e: #{energy}/ has #{self.energy
          }, z: #{zetium}/has #{self.zetium}"
      ) if metal > self.metal || energy > self.energy ||
        zetium > self.zetium

      if target.is_a?(SsObject::Planet)
        raise GameLogicError.new(
          "Transporter must be in #{target} to be able to unload resources!"
        ) if location != target.location
      else
        target = Wreckage.in_location(location).first ||
          Wreckage.new(:location => location)
      end

      volume = self.class.calculate_resources_volume(self.metal,
        self.energy, self.zetium)

      [[:metal, metal], [:energy, energy], [:zetium, zetium]].each do
        |resource, amount|
        target.send("#{resource}=", target.send(resource) + amount)
        send("#{resource}=", send(resource) - amount)
      end

      # Recalculate how much volume resources left on transporter take up.
      new_volume = self.class.calculate_resources_volume(self.metal,
        self.energy, self.zetium)
      self.stored -= volume - new_volume

      transaction do
        save!
        target.save!
        EventBroker.fire(self, EventBroker::CHANGED)
      end
    end

    def update_transporter_units(units, location)
      Unit.update_location_all(location, {:id => units.map(&:id)})
      # Update unit location before dispatching it to client
      units.each { |unit| unit.location = location }

      EventBroker.fire([self] + units, EventBroker::CHANGED)
    end
  end

  module ClassMethods
    # Returns +Unit+ storage for _level_.
    def storage; property('storage', 0); end

    # How much storage does this +Unit+ take.
    def volume; property('volume'); end

    # How much storage does this +Unit+ unload per tick in combat.
    def unload_per_tick(level)
      evalproperty('unload_per_tick', nil, 'level' => level)
    end

    # Calculates total volume of _units_.
    def calculate_volume(units)
      units.reduce(0) do |sum, unit|
        volume = unit.volume
        raise GameLogicError.new("#{unit} does not have volume!") \
          if volume.nil?

        sum + volume
      end
    end
  
    # Calculates total volume of _metal_, _energy_ and _zetium_.
    def calculate_resources_volume(metal, energy, zetium)
      (metal / CONFIG["units.transportation.volume.metal"]).ceil +
      (energy / CONFIG["units.transportation.volume.energy"]).ceil +
      (zetium / CONFIG["units.transportation.volume.zetium"]).ceil
    end
  end
end
