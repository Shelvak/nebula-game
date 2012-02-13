class CallbackManager
  class UnknownEvent < ArgumentError
    def initialize(klass, id, event)
      super("Unrecognized event #{CallbackManager::METHOD_NAMES[event]} (#{
        event} for #{klass} ID #{id}")
    end
  end

  include Celluloid
  include NamedLogMessages
  
  # Constructable has finished upgrading.
  EVENT_UPGRADE_FINISHED = 0
  # Constructor has finished construction of constructable.
  EVENT_CONSTRUCTION_FINISHED = 1
  # There is no more energy in the SsObject.
  EVENT_ENERGY_DIMINISHED = 2
  # Units should be moved.
  EVENT_MOVEMENT = 3
  # Object must be destroyed
  EVENT_DESTROY = 4
  # Exploration is finished in Planet
  EVENT_EXPLORATION_COMPLETE = 5
  # Cooldown has expired for building.
  EVENT_COOLDOWN_EXPIRED = 6
  # NPC raid on the planet.
  EVENT_RAID = 7
  # Scheduled check for inactive player. This is also defined in SpaceMule.
  EVENT_CHECK_INACTIVE_PLAYER = 8
  # Spawn something in the object.
  EVENT_SPAWN = 9
  # One VIP tick has occurred.
  EVENT_VIP_TICK = 10
  # VIP has expired.
  EVENT_VIP_STOP = 11
  # Create system offer for creds -> metal in galaxy.
  EVENT_CREATE_METAL_SYSTEM_OFFER = 12
  # Create system offer for creds -> energy in galaxy.
  EVENT_CREATE_ENERGY_SYSTEM_OFFER = 13
  # Create system offer for creds -> zetium in galaxy.
  EVENT_CREATE_ZETIUM_SYSTEM_OFFER = 14
  
  METHOD_NAMES = {
    EVENT_UPGRADE_FINISHED => :upgrade_finished,
    EVENT_CONSTRUCTION_FINISHED => :construction_finished,
    EVENT_ENERGY_DIMINISHED => :energy_diminished,
    EVENT_MOVEMENT => :movement,
    EVENT_DESTROY => :destroy,
    EVENT_EXPLORATION_COMPLETE => :exploration_complete,
    EVENT_COOLDOWN_EXPIRED => :cooldown_expired,
    EVENT_RAID => :raid,
    EVENT_CHECK_INACTIVE_PLAYER => :check_inactive_player,
    EVENT_SPAWN => :spawn,
    EVENT_VIP_TICK => :vip_tick,
    EVENT_VIP_STOP => :vip_stop,
    EVENT_CREATE_METAL_SYSTEM_OFFER => :create_metal_system_offer,
    EVENT_CREATE_ENERGY_SYSTEM_OFFER => :create_energy_system_offer,
    EVENT_CREATE_ZETIUM_SYSTEM_OFFER => :create_zetium_system_offer,
  }

  def to_s
    "callback_manager"
  end

  def initialize
    @connection = ActiveRecord::Base.connection_pool.checkout
    @running = false
    @pause = false
    tick!(true) # Tick first time with failed callbacks.
    run!
  end

  def finalize
    ActiveRecord::Base.connection_pool.checkin(@connection)
  end

  def run
    raise "Cannot run callback manager while it is running!" if @running
    @running = true

    loop do
      if @pause
        @pause = false
        wait :resume
      end

      tick
      Kernel.sleep(1) # Wait 1 second before next tick.
    end
  end

  # Pauses callback manager. Callbacks will not be
  def pause
    info "Pausing."
    @pause = true
  end

  def resume
    info "Resuming."
    signal :resume
  end

  # Run every callback that is not processed and should have happened by now.
  def tick(include_all=false)
    now = Time.now.to_s(:db)
    conditions = include_all \
      ? "ends_at <= '#{now}'" \
      : "ends_at <= '#{now}' AND processed=0 AND failed=0"
    sql = "WHERE #{conditions} ORDER BY ends_at"

    get_callback = lambda do
      LOGGER.except(:debug) do
        row = self.class.get(sql, @connection)
        row = Callback.new(
          row['id'], row['class'], row['object_id'], row['event'],
          row['ruleset'], row['time']
        ) unless row.nil?
        row
      end
    end

    # Request unprocessed entries that have hit.
    callback = get_callback.call

    until callback.nil?
      info callback.to_s

      # Mark this row as sent to processing.
      LOGGER.except(:debug) do
        @connection.execute(
          "UPDATE `callbacks` SET processed=1 WHERE id=#{callback.id}"
        )
      end
      dispatch(callback)

      callback = get_callback.call
    end
  end

  private
  def dispatch(callback)
    Actor[:dispatcher].call!(callback.klass, callback.method_name, callback)
  end

  class << self
    def get_class(object)
      object.class.to_s
    end

    # Register _event_ that will happen at _time_ on _object_. It will
    # be scoped in _ruleset_. Beware that ruleset is not considered when
    # updating or checking for object existence.
    def register(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      raise ArgumentError.new("object was nil!") if object.nil?
      raise ArgumentError.new("object was not a ActiveRecord::Base, but #{
        object.class} with superclass #{object.class.superclass}!") \
        unless object.is_a?(ActiveRecord::Base)

      time ||= object.upgrade_ends_at

      LOGGER.debug("Registering event '#{METHOD_NAMES[event]
        }' at #{time.to_s(:db)} for #{object}", TAG)

      raise ArgumentError.new("object #{object} does not have id!") \
        if object.id.nil?

      ActiveRecord::Base.connection.execute(
        "INSERT INTO callbacks SET class='#{get_class(object)
          }', ruleset='#{CONFIG.set_scope}', object_id=#{object.id
          }, event=#{event}, ends_at='#{time.to_s(:db)}'"
      )
    end

    # Update existing record.
    def update(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      time ||= object.upgrade_ends_at

      LOGGER.debug("Updating event '#{METHOD_NAMES[event]
        }' at #{time.to_s(:db)} for #{object}", TAG)

      ActiveRecord::Base.connection.execute(
        "UPDATE callbacks SET ends_at='#{time.to_s(:db)}' WHERE class='#{
          get_class(object)}' AND object_id=#{object.id} AND event=#{event}"
      )
    end

    def register_or_update(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      register(object, event, time)
    rescue ActiveRecord::RecordNotUnique
      update(object, event, time)
    end

    def has?(object, event, time=nil)
      time_condition = case time
      when nil
        "1=1"
      when Range
        "(ends_at BETWEEN '#{time.first.to_s(:db)}' AND '#{
            time.last.to_s(:db)}')"
      else
        "ends_at='#{time.to_s(:db)}'"
      end

      ! ActiveRecord::Base.connection.select_value(
        "SELECT 1 FROM callbacks WHERE class='#{get_class(object)
         }' AND object_id=#{object.id} AND event=#{event} AND #{time_condition
        } LIMIT 1"
      ).nil?
    end

    def unregister(object, event=EVENT_UPGRADE_FINISHED)
      LOGGER.debug("unregistering event '#{METHOD_NAMES[event]
        }' for #{object}", TAG)

      ActiveRecord::Base.connection.execute(
        "DELETE FROM callbacks WHERE class='#{get_class(object)
          }' AND object_id=#{object.id} AND event=#{event}"
      )
    end

    def get(sql, connection=nil)
      connection ||= ActiveRecord::Base.connection
      connection.select_one(
        "SELECT id, class, ruleset, object_id, event, ends_at FROM callbacks
          #{sql} LIMIT 1"
      )
    end


  end
end
