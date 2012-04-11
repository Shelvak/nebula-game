module Parts
  module Upgradable
    def self.included(klass)
      klass.scope :upgrading,
        {:conditions => "upgrade_ends_at IS NOT NULL"}
      klass.scope :not_upgrading,
        {:conditions => "upgrade_ends_at IS NULL"}
      klass.validate :validate_upgrade_resources, :if => lambda { |record|
        record.just_started? && ! record.skip_resources?
      }
      klass.before_save :run_upgrade_callbacks_before_save
      klass.after_save :run_upgrade_callbacks_after_save
      klass.send(:attr_writer, :skip_resources)

      klass.instance_eval do
        include InstanceMethods
        before_destroy :on_destroy
      end
      klass.extend ClassMethods
    end

    module InstanceMethods
      def skip_resources?; !! @skip_resources; end
      def max_level; self.class.max_level; end

      # Calculate upgrade time for model. Block can be given to calculate
      # upgrade time, otherwise default calculation is used. The block must
      # return on Fixnum which is seconds needed for upgrade.
      #
      # This method also ensure that upgrade time is never < 1.
      #
      def upgrade_time(for_level=nil, *args)
        for_level ||= self.level
        value = calculate_upgrade_time(for_level, *args)
        value < 1 ? 1 : value
      end

      # Actual calculation of upgrade time.
      def calculate_upgrade_time(for_level, *args)
        constructor_percentage = 100.0 - construction_mod

        constructor_percentage = CONFIG[
          'buildings.constructor.min_time_percentage'
        ] if constructor_percentage < CONFIG[
          'buildings.constructor.min_time_percentage'
        ]

        (
          evalproperty('upgrade_time', nil, 'level' => for_level) *
          constructor_percentage / 100.0
        ).floor
      end

      # Starts upgrade.
      def upgrade(&block)
        check_upgrade!
        
        self.pause_remainder = upgrade_time(level + 1)
        resume
        @upgrade_status = :just_started
        block.call if block
      end

      # Check upgrade logic validations. Raise GameLogicError if something
      # is wrong.
      def check_upgrade!
        raise GameLogicError.new("Cannot upgrade, not finished!") \
          unless finished?
        raise ArgumentError.new("level cannot be nil!") if level.nil?
        raise GameLogicError.new(
          "Cannot upgrade, at max level #{level}!"
        ) if level >= max_level
      end

      # Resumes paused upgrade
      def resume(&block)
        raise GameLogicError.new("Cannot resume, not paused!") \
          unless paused?

        block.call if block

        self.upgrade_ends_at = pause_remainder.seconds.from_now
        if self.pause_remainder == 0
          self.pause_remainder = nil
          on_upgrade_finished
        else
          self.pause_remainder = nil
          @upgrade_status = :just_resumed
        end
      end

      # Pauses construction
      def pause(&block)
        raise GameLogicError.new("Cannot pause, not upgrading!") \
          unless upgrading?

        block.call if block

        self.pause_remainder = calculate_pause_remainder
        self.upgrade_ends_at = nil
        @upgrade_status = :just_paused
      end
      
      # Cancels upgrading. Returns unused resources back to planet. Reduces
      # given points for player.
      # 
      # Unused resources are calculated from cost * time remainder.
      # E.g. if 35% of building is built, it will only give back 65% of the
      # cost.
      #
      # Fails to cancel if being upgraded by constructor and _by_constructor_
      # is not true.
      #
      def cancel!(by_constructor=false)
        raise GameLogicError.
          new("Cannot cancel upgrading if not upgrading!") unless upgrading?
        raise GameLogicError.new(
          "Cannot cancel #{self} which is being upgraded by constructor!"
        ) unless by_constructor || CallbackManager.
          has?(self, CallbackManager::EVENT_UPGRADE_FINISHED)
        
        percentage_left = 
          (upgrade_ends_at - Time.now) / upgrade_time(level + 1)
        metal = (metal_cost(level + 1) * percentage_left).floor
        energy = (energy_cost(level + 1) * percentage_left).floor
        zetium = (zetium_cost(level + 1) * percentage_left).floor

        planet.increase(:metal => metal, :energy => energy, :zetium => zetium)
        
        self.upgrade_ends_at = nil
        CallbackManager.
          unregister(self, CallbackManager::EVENT_UPGRADE_FINISHED)
        # Invoked by Unit/Building#cancel!
        yield if block_given?

        if level == 0
          destroy!
        else
          save!
        end
        planet.save!
      end

      # Accelerate upgrading. Returns number of seconds reduced.
      #
      def accelerate!(time, cost)
        player = self.player
        raise GameLogicError.new(
          "Player does not have enough credits! Has: #{player.creds
          }, required: #{cost}"
        ) if player.creds < cost

        pause
        # Clear upgrade status because we're not going to save the record
        # right now and other functionality depends on it.
        @upgrade_status = nil
        if time == Creds::ACCELERATE_INSTANT_COMPLETE
          # Instant-complete
          seconds_reduced = self.pause_remainder
          self.pause_remainder = 0
        else
          seconds_reduced = time
          self.pause_remainder -= time
          self.pause_remainder = 0 if self.pause_remainder < 0
        end
        # Some code depend on this variable being set to know what to do
        @just_accelerated = true
        resume
        
        stats = CredStats.accelerate(self, cost, time, seconds_reduced)
        player.creds -= cost

        stats.save!
        player.save!
        save!
        EventBroker.fire(self, EventBroker::CHANGED)
        Objective::Accelerate.progress([self])

        seconds_reduced
      end

      # #upgrade and #save!
      def upgrade!
        upgrade
        save!
      end

      # #resume and #save!
      def resume!
        resume
        save!
      end

      # #pause and #save!
      def pause!
        pause
        save!
      end

      def upgrade_status
        if @upgrade_status
          @upgrade_status
        elsif ! self.pause_remainder.nil?
          :paused
        elsif self.upgrade_ends_at.nil?
          :finished
        else
          :upgrading
        end
      end

      def change_while_upgrading!(attributes={})
        pause!
        attributes.each do |key, value|
          send("#{key}=", value)
        end
        resume!
      end

      def just_started?; upgrade_status == :just_started; end
      def just_paused?; upgrade_status == :just_paused; end
      def just_resumed?; upgrade_status == :just_resumed; end
      def just_finished?; upgrade_status == :just_finished; end
      def finished?
        [:just_finished, :finished].include?(upgrade_status)
      end
      def paused?; [:just_paused, :paused].include?(upgrade_status); end
      def upgrading?; upgrade_status == :upgrading; end

      def metal_cost(for_level=nil)
        self.class.metal_cost(for_level || level)
      end

      def energy_cost(for_level=nil)
        self.class.energy_cost(for_level || level)
      end

      def zetium_cost(for_level=nil)
        self.class.zetium_cost(for_level || level)
      end

      # Return number of points obtained from upgrade to current level.
      def points_on_upgrade
        Resources.total_volume(
          self.metal_cost(level),
          self.energy_cost(level),
          self.zetium_cost(level)
        )
      end

      # Return number of points which should be removed when this upgradable
      # is destroyed.
      def points_on_destroy
        (1..level).inject(0) do |sum, level|
          sum + Resources.total_volume(
            self.metal_cost(level),
            self.energy_cost(level),
            self.zetium_cost(level)
          )
        end
      end

      def points_attribute; self.class.points_attribute; end

      def register_upgrade_finished_callback?
        @_register_upgrade_finished_callback.nil? \
          ? true : @_register_upgrade_finished_callback
      end

      def register_upgrade_finished_callback=(value)
        @_register_upgrade_finished_callback = value
      end

      private
      # Calculates pause remainder when #pause is called.
      #
      # Override to provide custom logic
      def calculate_pause_remainder
        upgrade_ends_at.to_i - Time.now.to_i
      end

      def validate_upgrade_resources
        if (
          planet.metal < metal_cost(level + 1) \
          || planet.energy < energy_cost(level + 1) \
          || planet.zetium < zetium_cost(level + 1)
        )
          raise NotEnoughResources.new("Insuffient resources! Metal: #{
              metal_cost(level + 1)}, energy: #{
              energy_cost(level + 1)}, zetium: #{
              zetium_cost(level + 1)}. Resources entry: #{
              planet.to_s}", self)
        end
      end

      def run_upgrade_callbacks(type)
        status = upgrade_status
        # Start events are: :just_started, :just_paused, :just_resumed
        # Finished events come through .on_upgrade_finished(id)
        case status
        when :just_started, :just_paused, :just_resumed, :just_finished
          send("on_upgrade_#{status}_#{type}")
          @upgrade_status = nil if type == :after_save
        end
      end

      def run_upgrade_callbacks_before_save
        run_upgrade_callbacks(:before_save)
      end

      def run_upgrade_callbacks_after_save
        run_upgrade_callbacks(:after_save)
      end

      ### just started ###

      # Called when building has been started upgrading (before record
      # save).
      #
      # Calls #on_upgrade_just_resumed_before_save
      def on_upgrade_just_started_before_save
        on_upgrade_reduce_resources unless skip_resources?

        on_upgrade_just_resumed_before_save
      end

      def on_upgrade_reduce_resources
        metal_cost = self.metal_cost(level + 1)
        energy_cost = self.energy_cost(level + 1)
        zetium_cost = self.zetium_cost(level + 1)

        planet.increase!(:metal => -metal_cost, :energy => -energy_cost,
                         :zetium => -zetium_cost)
      end

      # Override me to implement logic for increasing player points based
      # on upgrading things.
      def increase_player_points(points)
        player = self.player
        self.class.change_player_points(player, points_attribute, points) \
          unless player.nil?
      end

      def decrease_player_points(points)
        player = self.player
        self.class.change_player_points(player, points_attribute, -points) \
          unless player.nil?
      end

      # Called when upgradable has been started upgrading (after record
      # save).
      #
      # Calls #on_upgrade_just_resumed_after_save
      def on_upgrade_just_started_after_save
        on_upgrade_just_resumed_after_save
      end

      ### just resumed ###

      def on_upgrade_just_resumed_before_save

      end
      
      def on_upgrade_just_resumed_after_save
        CallbackManager.register_or_update(
          self, CallbackManager::EVENT_UPGRADE_FINISHED, upgrade_ends_at
        ) if register_upgrade_finished_callback?

        true
      end

      ### just paused ###

      def on_upgrade_just_paused_before_save
      end

      def on_upgrade_just_paused_after_save
        CallbackManager.unregister(
          self, CallbackManager::EVENT_UPGRADE_FINISHED
        )
      end

      ### finished ###

      def on_upgrade_finished!
        on_upgrade_finished
        save!
      end

      def on_upgrade_finished
        raise ArgumentError.new("Cannot finish because #{self.inspect
          } is not upgrading!") unless upgrading?

        self.pause_remainder = nil
        self.upgrade_ends_at = nil
        self.level += 1
        @upgrade_status = :just_finished
      end

      def on_upgrade_just_finished_before_save
      end

      def on_upgrade_just_finished_after_save
        increase_player_points(points_on_upgrade)
        # Unregister just finished in case we accelerated upgrading.
        CallbackManager.unregister(
          self, CallbackManager::EVENT_UPGRADE_FINISHED
        )
        EventBroker.fire(
          self, EventBroker::CHANGED, EventBroker::REASON_UPGRADE_FINISHED
        )
      end

      # This is called as a before_destroy callback.
      def on_destroy
        decrease_player_points(points_on_destroy)
      end
    end

    module ClassMethods
      def max_level; property('max_level'); end

      def metal_cost(level); cost(level, "metal"); end

      def energy_cost(level); cost(level, "energy"); end

      def zetium_cost(level); cost(level, "zetium"); end

      def cost(level, resource)
        evalproperty("#{resource}.cost", 0, 'level' => level).ceil
      end
      
      def change_player_points(player, points_attribute, points)
        player.send(:"#{points_attribute}=",
          player.send(points_attribute) + points)
        player.save!
      end

      def points_attribute
        raise NotImplementedError.new(
          "You should override me to provide what kind of points I operate on!"
        )
      end

      def on_callback(id, event)
        if event == CallbackManager::EVENT_UPGRADE_FINISHED
          model = find(id)
          # Callbacks are private
          model.send(:on_upgrade_finished!)

          model
        elsif defined?(super)
          super(id, event)
        else
          raise CallbackManager::UnknownEvent.new(self, id, event)
        end
      end
    end
  end
end
