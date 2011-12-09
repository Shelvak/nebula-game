module Parts::Constructor
	def self.included(receiver)
    receiver.extend ConditionalExtender
    # This must be always included because callbacks access base class
    # instead of subclass.
    receiver.extend OnCallback
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
          belongs_to :constructable, :polymorphic => true
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

  # This must be always included because callbacks access base class instead
  # of subclass.
  module OnCallback
    # Process events when upgrade manager
    def on_callback(id, event)
      if event == CallbackManager::EVENT_CONSTRUCTION_FINISHED
        model = find(id)
        model.send(:on_construction_finished!)
      else
        super(id, event)
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
        hash["construction_queue_entries"] = construction_queue_entries.map(
          &:as_json)
        hash["build_in_2nd_flank"] = build_in_2nd_flank
        hash["build_hidden"] = build_hidden
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
      count = free_slots if count > free_slots

      transaction do
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
    end

    def accelerate_construction!(time, cost)
      raise GameLogicError.new(
        "Cannot accelerate if not working!"
      ) unless working?

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

    def on_construction_finished!(finish_constructable=true)
      # Store aggregated queue errors.
      not_enough_resources = []

      # We might not need to finish constructable if it was cancelled.
      if finish_constructable
        constructable = self.constructable

        # Temp. workaround to prevent constructors getting stuck - still need
        # to understand what is wrong with it.
        begin
          before_finishing_constructable(constructable)
          # Call #on_upgrade_finished! because we have no callback registered.
          constructable.send(:on_upgrade_finished!)
        rescue Exception => e
          if App.in_production?
            LOGGER.error("FAIL @ constructor #{self.inspect}:\n#{e.to_log_str}")
          else
            raise e
          end
        end
      end

      begin
        queue_entry = ConstructionQueue.shift(id)

        if queue_entry
          construct_model!(queue_entry.constructable_type, queue_entry.prepaid?,
                           queue_entry.params)
        else
          construct_model!(nil, nil, nil)
        end

        self.constructable
      rescue ActiveRecord::RecordInvalid
        # Well, if we somehow got an invalid request just dump it then.
        retry
      # Iterate through construction finished until queue is empty
      rescue NotEnoughResources => error
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

    # TODO: unregister from CM upon destruction

    def params_for_type(type)
      params = {}

      case type
      when /^Building/
        params[:planet_id] = self.planet_id
      when /^Unit/
        params[:location_id] = self.planet_id
        params[:location_type] = Location::SS_OBJECT
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
        if type =~ /^Unit/
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
        model.construction_mod = self.constructor_mod +
          self.level_constructor_mod
        # Don't register upgrade finished callback, because we will call it
        # for the model when we get #on_construction_finished! called.
        model.register_upgrade_finished_callback = false
        model.skip_resources = true if prepaid
        model.upgrade!
        EventBroker.fire(model, EventBroker::CREATED)

        self.constructable = model
        self.state = Building::STATE_WORKING

        CallbackManager.register(self,
          CallbackManager::EVENT_CONSTRUCTION_FINISHED,
          model.upgrade_ends_at)
      end

      save!
      EventBroker.fire(self, EventBroker::CHANGED,
        EventBroker::REASON_CONSTRUCTABLE_CHANGED)

      model
    end

    def before_finishing_constructable(constructable)
      if constructable.is_a?(Unit)
        constructable.flank = 1 if build_in_2nd_flank?
        constructable.hidden = true if build_hidden?
      end

      constructable
    end
	end
end