module Parts
  module Upgradable
    def self.included(klass)
      klass.scope :upgrading,
        {:conditions => "upgrade_ends_at IS NOT NULL"}
      klass.validate :validate_upgrade_resources, :if => lambda { |record|
        record.just_started? && ! record.skip_resources?
      }
      klass.before_save :run_upgrade_callbacks_before_save
      klass.after_save :run_upgrade_callbacks_after_save
      klass.after_find :update_upgrade_properties!,
        :if => Proc.new { |r|
          r.upgrade_ends_at && r.last_update.to_i < Time.now.to_i
        }
      klass.send(:attr_writer, :skip_resources)
      
      klass.send :include, InstanceMethods
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
          (constructor_percentage) / 100.0
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

        self.last_update = Time.now
        self.upgrade_ends_at = calculate_upgrade_ends_at
        self.pause_remainder = nil
        @upgrade_status = :just_resumed
      end

      # Pauses construction
      def pause(&block)
        raise GameLogicError.new("Cannot pause, not upgrading!") \
          unless upgrading?

        block.call if block

        self.pause_remainder = calculate_pause_remainder
        self.last_update = nil
        self.upgrade_ends_at = nil
        @upgrade_status = :just_paused
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
        self.class.evalproperty('metal.cost', 0,
          'level' => for_level || level)
      end

      def energy_cost(for_level=nil)
        self.class.evalproperty('energy.cost', 0,
          'level' => for_level || level)
      end

      def zetium_cost(for_level=nil)
        self.class.evalproperty('zetium.cost', 0,
          'level' => for_level || level)
      end

      private
      def update_upgrade_properties!(&block)
        # Ensure that Time.now is not greater than upgrade_ends_at.
        now = [Time.now, upgrade_ends_at].min.drop_usec
        diff = (now - last_update).to_f
        self.last_update = now
        
        block.call(now, diff) if block

        save!
      end

      # Calculates when upgrade should end when #resume is called.
      #
      # Override to provide custom logic
      def calculate_upgrade_ends_at
        last_update + pause_remainder
      end

      # Calculates pause remainder when #pause is called.
      #
      # Override to provide custom logic
      def calculate_pause_remainder
        upgrade_ends_at.to_i - last_update.to_i
      end

      def validate_upgrade_resources
        planet = SsObject::Planet.find(planet_id)
        if (
          planet.metal < metal_cost(level + 1) \
          or planet.energy < energy_cost(level + 1) \
          or planet.zetium < zetium_cost(level + 1)
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
        SsObject::Planet.change_resources(planet_id,
          -metal_cost(level + 1),
          -energy_cost(level + 1),
          -zetium_cost(level + 1)
        )
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
        CallbackManager.register(self)
      end

      ### just paused ###

      def on_upgrade_just_paused_before_save
      end

      def on_upgrade_just_paused_after_save
        CallbackManager.unregister(self)
      end

      ### finished ###

      def on_upgrade_finished
        self.pause_remainder = nil
        self.upgrade_ends_at = nil
        self.last_update = nil
        self.level += 1
        @upgrade_status = :just_finished
      end

      def on_upgrade_just_finished_before_save
      end

      def on_upgrade_just_finished_after_save
        EventBroker.fire(self, EventBroker::CHANGED,
          EventBroker::REASON_UPGRADE_FINISHED)
      end
    end

    module ClassMethods
      def max_level; property('max_level'); end

      def on_callback(id, event)
        if event == CallbackManager::EVENT_UPGRADE_FINISHED
          model = find(id)
          # Callbacks are private
          model.send(:on_upgrade_finished)
          model.save!

          model
        else
          super(id, event)
        end
      end
    end
  end
end
