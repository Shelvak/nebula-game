module Parts::Constructor
  # Proxy class for #constructable property of constructors.
  class ConstructableProxy < ActiveSupport::BasicObject
    TYPE_BUILDING = :building
    TYPE_UNIT = :unit

    TYPES = [TYPE_BUILDING, TYPE_UNIT]

    def self.converter(constructable)
      case constructable
      when ::Building then new(constructable, TYPE_BUILDING, nil)
      when ::Unit then new(constructable, TYPE_UNIT, nil)
      else raise ArgumentError,
        "Unknown constructable: #{constructable.inspect}"
      end
    end

    def self.from_mapping(building_id, unit_id)
      if ! building_id.nil?
        new(nil, TYPE_BUILDING, building_id)
      elsif ! unit_id.nil?
        new(nil, TYPE_UNIT, unit_id)
      else
        raise ArgumentError, "All constructor arguments are nil!"
      end
    end

    def initialize(object, type, id)
      # Cannot use typesig here, because of BasicObject.
      raise ::ArgumentError, "Unknown type #{type}!" unless TYPES.include?(type)
      raise ::ArgumentError,
        "Cannot create proxy if both object and id is nil for type #{type}!" \
        if object.nil? && id.nil?

      @obj = object
      @type = type
      @id = id
    end

    # For #as_json of constructor.
    def __type; @type == TYPE_BUILDING ? "Building" : "Unit"; end
    # For #as_json of constructor.
    def __id; @id || @obj.id; end

    # For #composed_of mapping.
    def __db_building_id; @type == TYPE_BUILDING ? __id : nil; end
    # For #composed_of mapping.
    def __db_unit_id; @type == TYPE_UNIT ? __id : nil; end

    # #composed_of freezes object to prevent changes to it. Ignore it as we take
    # care to save that object.
    def freeze(*args); end

    # Allow raising exceptions.
    def raise(*args); ::Kernel.raise(*args); end

    # Ensure methods defined in this proxy are called with #send.
    def send(*args); __send__(*args); end
    def method_missing(*args); __proxy_obj.send(*args); end

    private
    def __proxy_obj
      @obj ||= case @type
      when TYPE_BUILDING then ::Building.find(@id)
      when TYPE_UNIT then ::Unit.find(@id)
      else
        raise "Unknown constructable type: #{@type.inspect} (id #{@id.inspect})"
      end
    end
  end

  def self.included(receiver)
    receiver.extend ConditionalExtender
    receiver.extend BaseClassMethods
  end

  # Extend subclass with functionality if that subclass is a constructor.
  module ConditionalExtender
    def inherited(subclass)
      super(subclass)
      if subclass.constructor?
        subclass.extend ClassMethods
        subclass.instance_eval do
          include InstanceMethods
          # FK :dependent => :delete_all
          has_many :construction_queue_entries,
            :foreign_key => :constructor_id
          protected :construct_model!, :params_for_type
          composed_of :constructable,
            :class_name => ConstructableProxy.to_s,
            :mapping => [
              [:constructable_building_id, :__db_building_id],
              [:constructable_unit_id, :__db_unit_id],
            ],
            :constructor => :from_mapping,
            :converter => :converter,
            :allow_nil => true

          before_save do
            # Ensure changes to constructable are persisted when you save the
            # parent.
            constructable.try(:save!)
          end

          # Destroy constructable if it's currently present.
          before_destroy do
            # Reset state to active so we could deactivate.
            if working?
              ConstructionQueue.clear(id)
              cancel_constructable!
              self.state = Building::STATE_ACTIVE
              deactivate
            end

            true
          end
        end
      end
    end
  end

  # Class methods for base class.
  module BaseClassMethods
    def constructor?; ! property('constructor.items').nil?; end

    def on_callback(id, event)
      if event == CallbackManager::EVENT_CONSTRUCTION_FINISHED
        model = find(id)
        model.send(:on_construction_finished!)
      elsif defined?(super)
        super(id, event)
      else
        raise CallbackManager::UnknownEvent.new(self, id, event)
      end
    end
  end

  module ClassMethods
    # Returns maximum number of queue elements for this constructor.
    def queue_max; property('queue.max') || 0; end

    # Constructor mod based on current level.
    def level_constructor_mod(level)
      evalproperty('mod.construction', 0, 'level' => level)
    end

    def each_constructable_item
      (property('constructor.items') || []).each do |item|
        base, name = item.split('/')

        yield item, base, name
      end
    end

    # Does this constructor constructs units?
    def constructs_units?
      each_constructable_item do |item, base, name|
        return true if base == "unit"
      end

      false
    end

    # Return if constructor can construct given type.
    #
    # Type must be given in "Foo::Bar" or "foo/bar" notations.
    #
    def can_construct?(type)
      type = type.underscore
      base, name = type.split('/')
      each_constructable_item do |item, item_base, item_name|
        # Match glob
        if item_name == '*'
          return true if base == item_base
        # Exact match
        else
          return true if type == item
        end
      end

      false
    end
  end

  module InstanceMethods
    def as_json(options=nil)
      super do |hash|
        hash["construction_queue_entries"] = construction_queue_entries.
          map(&:as_json)
        hash["build_in_2nd_flank"] = build_in_2nd_flank
        hash["build_hidden"] = build_hidden
        # Constructable might be nil and we cannot use #try because it is
        # proxied.
        if constructable.nil?
          hash["constructable_type"] = nil
          hash["constructable_id"] = nil
        else
          hash["constructable_type"] = constructable.__type
          hash["constructable_id"] = constructable.__id
        end
      end
    end

    def can_construct?(type); self.class.can_construct?(type); end
    def slots_taken; ConstructionQueue.count(id); end
    def free_slots; queue_max - slots_taken; end
    def queue_max; self.class.queue_max; end

    # Constructor mod based on current level.
    def level_constructor_mod; self.class.level_constructor_mod(level); end

    # Is the ConstructionQueue for this constructor full?
    def queue_full?
      free_slots == 0
    end

    def upgrade
      raise GameLogicError.new("Cannot upgrade while constructing!") \
        if working?
      super
    end

    # Cancels constructing whatever it was constructing. Returns part of
    # the resources back.
    def cancel_constructable!
      raise GameLogicError.new("Constructor isn't working!") unless working?
      constructable.cancel!(true)
      CallbackManager.unregister(self,
        CallbackManager::EVENT_CONSTRUCTION_FINISHED)
      on_construction_finished!(false)
    end

    # Construct and upgrade building.
    #
    # If _count_ is > 1 then starts constructing and queues items.
    #
    # If there is not enough free slots, count will be reduced to match
    # free slot count.
    #
    def construct!(type, prepaid, params={}, count=1)
      typesig binding,
              String, Boolean, Hash, Fixnum

      raise Building::BuildingInactiveError if inactive?
      raise GameLogicError.new(
        "Constructor #{self.class.to_s} cannot construct #{type}!"
      ) unless can_construct?(type)
      raise GameLogicError.new(
        "#{type} is not constructable!"
      ) unless type.constantize.constructable?
      raise GameLogicError.new(
        "Constructor is working and his queue is full!"
      ) if working? and queue_full?

      params.symbolize_keys!
      params.merge!(params_for_type(type))

      free_slots = self.free_slots
      free_slots += 1 unless working?
      raise GameLogicError,
        "Tried to construct #{count} entries, but only #{free_slots
        } are available!" if count > free_slots

      if working?
        enqueue!(type, prepaid, count, params)
      else
        model = construct_model!(type, false, params)

        if count > 1
          entry = enqueue!(type, prepaid, count - 1, params)
          {:model => model, :construction_queue_entry => entry}
        else
          model
        end
      end
    end

    def accelerate_construction!(time, cost)
      raise GameLogicError, "Cannot accelerate if not working!" unless working?

      # #accelerate! might complete the constructable, so make sure its flank
      # is set. This is a hack and I know it. :( - arturaz
      constructable = self.constructable
      before_finishing_constructable(constructable)
      # Don't register upgrade finished callback if partially accelerating.
      constructable.register_upgrade_finished_callback = false
      constructable.accelerate!(time, cost)
      if constructable.upgrading?
        CallbackManager.update(self,
          CallbackManager::EVENT_CONSTRUCTION_FINISHED,
          constructable.upgrade_ends_at
        )
      else
        CallbackManager.unregister(
          self, CallbackManager::EVENT_CONSTRUCTION_FINISHED
        )
        # Acceleration finishes constructable so we don't have to.
        on_construction_finished!(false)
      end

      true
    end

    # Accelerate all prepaid entries in the queue + currently constructing one.
    # Fails if there are non-prepaid entries.
    def mass_accelerate!(time, cost)
      player = self.planet.player
      raise GameLogicError, "You must be VIP to mass accelerate!" \
        unless player.vip?

      has_not_prepaid = construction_queue_entries.
        where(ConstructionQueueEntry.not_prepaid_condition).exists?
      raise GameLogicError,
        "Cannot accelerate all if constructor has non-prepaid entries in " +
        "queue!" if has_not_prepaid

      constructable = self.constructable
      raise GameLogicError, "Cannot mass accelerate if not constructing!" \
        if constructable.nil?

      flank = build_in_2nd_flank? ? 1 : 0
      hidden = build_hidden?
      location = planet.location_point
      construction_mod = model_construction_mod
      class_cache = {}

      units = []
      total_time = 0
      population = 0
      # Cannot explode data into (array, time) because time is a primitive
      # value ant we need to increment it.
      construction_queue_entries.each do |entry|
        raise GameLogicError,
          "Cannot only mass accelerate units, but wanted to accelerate #{
          entry.constructable_type}!" \
          unless entry.constructable_type.starts_with?("Unit::")

        entry.count.times do
          type = entry.constructable_type
          klass = class_cache[type] ||= type.constantize
          model = klass.new(entry.params)
          # To get time calculations right.
          model.construction_mod = construction_mod
          model.level = 1
          model.flank = flank
          model.hidden = hidden
          model.location = location

          units << model
          total_time += model.upgrade_time(1)
          population += model.population
        end
      end

      total_time += constructable.calculate_pause_remainder

      raise GameLogicError,
        "Time for all units is #{total_time}s, but only #{time}s were given!" \
        if total_time > time

      raise GameLogicError,
        "Needed #{cost} creds, but player only had #{player.creds}!" \
        if cost > player.creds

      # TODO: s2_par - modify deh_buffer to discard events on failure.
      # TODO: add credstats

      player.population -= population # Unit.give_units_raw will increase pop.
      player.creds -= cost
      Unit.give_units_raw(units, planet, player) # This also saves player

      ConstructionQueue.clear(id, false)
      # Reload queue entries after clearing.
      construction_queue_entries(true)
      on_construction_finished!
      CallbackManager.
        unregister(self, CallbackManager::EVENT_CONSTRUCTION_FINISHED)

      all_units = [constructable] + units
      grouped_counts = all_units.grouped_counts { |unit| unit.class.to_s }
      CredStats.mass_accelerate(
        player, self, cost, total_time, time, grouped_counts
      ).save!

      # Return constructed units.
      all_units
    end

    def on_construction_finished!(finish_constructable=true)
      # Store aggregated queue errors.
      not_enough_resources = []

      # We might not need to finish constructable if it was cancelled.
      if finish_constructable
        constructable = self.constructable
        before_finishing_constructable(constructable)
        # Call #on_upgrade_finished! because we have no callback registered.
        constructable.send(:on_upgrade_finished!)
      end

      begin
        queue_entry = ConstructionQueue.shift(id)

        if queue_entry
          construct_model!(
            queue_entry.constructable_type, queue_entry.prepaid?,
            queue_entry.params
          )
        else
          construct_model!(nil, nil, nil)
        end

        self.constructable
      rescue ActiveRecord::RecordInvalid
        # Well, if we somehow got an invalid request just dump it then.
        retry
      rescue NotEnoughResources => error
        # Iterate through construction finished until queue is empty
        not_enough_resources.push error.constructable
        retry
      rescue GameNotifiableError => error
        Notification.create_from_error(error)
        retry
      ensure
        unless not_enough_resources.blank? || player.nil?
          Notification.create_from_error(
            NotEnoughResourcesAggregated.new(self, not_enough_resources)
          )
        end
      end
    end

    def params_for_type(type)
      params = {}

      case type
      when /^Building/
        params[:planet_id] = self.planet_id
      when /^Unit/
        params[:location_ss_object_id] = self.planet_id
      end

      params
    end

    private
    # @param type [String]
    # @param params [Hash]
    def build_model(type, params)
      typesig binding, String, Hash

      model = type.constantize.new(params)
      model.player_id = SsObject.
        select("player_id").where(:id => model.location.id).c_select_value \
        if type.starts_with?("Unit")
      model.level = 0

      model
    end

    # @param type [String]
    # @param prepaid [Boolean]
    # @param count [Fixnum]
    # @param params [Hash]
    # @return [ConstructionQueueEntry]
    def enqueue!(type, prepaid, count, params)
      ConstructionQueue.push(id, type, prepaid, count, params)
    end

    def construct_model!(type, prepaid, params)
      # Stop constructing
      if type.nil?
        self.constructable = nil
        self.state = Building::STATE_ACTIVE
      else
        model = build_model(type, params)
        model.construction_mod = model_construction_mod
        # Don't register upgrade finished callback, because we will call it
        # for the model when we get #on_construction_finished! called.
        model.register_upgrade_finished_callback = false
        model.skip_resources = true if prepaid
        model.upgrade!
        EventBroker.fire(model, EventBroker::CREATED)

        self.constructable = model
        self.state = Building::STATE_WORKING

        CallbackManager.register(
          self, CallbackManager::EVENT_CONSTRUCTION_FINISHED,
          model.upgrade_ends_at
        )
      end

      save!
      dispatch_changed

      model
    end

    def dispatch_changed
      EventBroker.fire(
        self, EventBroker::CHANGED, EventBroker::REASON_CONSTRUCTABLE_CHANGED
      )
    end

    def model_construction_mod
      constructor_mod + level_constructor_mod
    end

    def before_finishing_constructable(constructable)
      if constructable.is_a?(Unit)
        constructable.flank = 1 if build_in_2nd_flank?
        constructable.hidden = build_hidden?
      end

      constructable
    end
  end
end