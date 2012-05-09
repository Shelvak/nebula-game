class CallbackManager
  include Celluloid
  include NamedLogMessages

  # Raised if callback already exists and is in future.
  class CallbackAlreadyExists < RuntimeError; end
  
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
  
  TYPES = {
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

  CLASS_TO_COLUMN = {
    Player => :player_id,
    Technology => :technology_id,
    Galaxy => :galaxy_id,
    SolarSystem => :solar_system_id,
    SsObject => :ss_object_id,
    Building => :building_id,
    Unit => :unit_id,
    RouteHop => :route_hop_id,
    Cooldown => :cooldown_id,
    Notification => :notification_id,
    Nap => :nap_id,
    CombatLog => :combat_log_id,
  }

  TAG = "callback_manager"
  TABLE_NAME = Callback::TABLE_NAME

  def to_s
    TAG
  end

  def initialize
    # Crash if dispatcher crashes, because we might have sent some messages
    # there that will never be processed if we don't restart.
    current_actor.link Actor[:dispatcher]

    @running = false
    @pause = false
    run!
  end

  def run
    raise "Cannot run callback manager while it is running!" if @running
    @running = true

    # Tick first time with failed callbacks. This should not be async.
    tick(true)

    loop do
      if @pause
        @pause = false
        wait :resume
      end

      sleep 1 # Wait 1 second before next tick.
      tick
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
    exclusive do
      with_db_connection do
        now = Time.now.to_s(:db)
        conditions = include_all \
          ? "ends_at <= '#{now}'" \
          : "ends_at <= '#{now}' AND processing=0"

        get_callback = lambda do |last_id|
          LOGGER.except(:debug) do
            # Ensure we don't end up in an endless loop trying to execute same
            # callback over and over again if it fails.
            skip_failed = last_id.nil? ? "" : " AND id > #{last_id.to_i}"
            sql = "WHERE #{conditions}#{skip_failed} ORDER BY ends_at"

            row = self.class.get(sql, connection)
            if row.nil?
              nil
            else
              klass, obj_id = self.class.parse_row(row)
              Callback.new(
                row['id'], klass, obj_id, row['event'],
                row['ruleset'], row['ends_at']
              )
            end
          end
        end

        # Request unprocessed entries that have hit.
        callback = get_callback.call(nil)

        until callback.nil?
          info "Fetched: #{callback}"

          # Mark this row as sent to processing.
          connection.execute(
            "UPDATE `#{TABLE_NAME}` SET processing=1 WHERE id=#{callback.id}"
          )
          Actor[:dispatcher].callback!(callback)

          callback = get_callback.call(callback.id)
        end
      end
    end
  end

  private
  def with_db_connection(&block)
    ActiveRecord::Base.connection_pool.with_connection(&block)
  end

  def connection
    ActiveRecord::Base.connection
  end

  class << self
    def parse_object(object)
      CLASS_TO_COLUMN.each do |klass, column|
        return [klass, column] if object.is_a?(klass)
      end

      raise ArgumentError, "Unknown column type for #{object.inspect}!"
    end

    def parse_row(row)
      CLASS_TO_COLUMN.each do |klass, column|
        id = row[column.to_s]
        return [klass, id] unless id.nil?
      end

      raise ArgumentError, "Cannot determine class/id for #{row.inspect}!"
    end

    # Register _event_ that will happen at _time_ on _object_. It will
    # be scoped in _ruleset_. Beware that ruleset is not considered when
    # updating or checking for object existence.
    def register(object, event, time, force_replace=true)
      typesig binding, ActiveRecord::Base, Fixnum, Time, Boolean

      LOGGER.info("Registering event '#{TYPES[event]
        }' at #{time.to_s(:db)} for #{object}", TAG)

      register_impl(object, event, time, force_replace)
    end

    # Update existing record.
    def update(object, event, time)
      typesig binding, ActiveRecord::Base, Fixnum, Time

      LOGGER.info("Updating event '#{TYPES[event]
        }' at #{time.to_s(:db)} for #{object}", TAG)

      register_impl(object, event, time, true)
    end

    def register_or_update(object, event, time)
      typesig binding, ActiveRecord::Base, Fixnum, Time

      register(object, event, time, true)
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

      klass, column = parse_object(object)
      check_event!(klass, event)
      ! ActiveRecord::Base.connection.select_value(
        "SELECT 1 FROM `#{TABLE_NAME}` WHERE #{column}=#{object.id} AND event=#{
        event} AND #{time_condition} LIMIT 1"
      ).nil?
    end

    def unregister(object, event)
      typesig binding, ActiveRecord::Base, Fixnum

      LOGGER.info("unregistering event '#{TYPES[event]}' for #{object}", TAG)

      klass, column = parse_object(object)
      check_event!(klass, event)
      ActiveRecord::Base.connection.execute(
        "DELETE FROM `#{TABLE_NAME}` WHERE #{column}=#{object.id} AND event=#{
        event}"
      )
    end

    def get(sql, connection=nil)
      connection ||= ActiveRecord::Base.connection
      connection.select_one("SELECT * FROM `#{TABLE_NAME}` #{sql} LIMIT 1")
    end

    private
    def check_event!(klass, event)
      method = :"#{TYPES[event]}_callback"
      raise ArgumentError, "#{klass} does not respond to #{method}!" \
        unless klass.respond_to?(method)
    end

    def register_impl(object, event, time, force_replace)
      raise ArgumentError.new("object #{object} does not have id!") \
        if object.id.nil?

      klass, column = parse_object(object)
      check_event!(klass, event)

      unless force_replace
        future_row = ActiveRecord::Base.connection.select_one(
          "SELECT id, ends_at FROM `#{TABLE_NAME}` WHERE #{column}='#{
          object.id.to_i}' AND event=#{event} AND ends_at > NOW() LIMIT 1"
        )

        raise ArgumentError, "Trying to register event #{TYPES[event]} on #{
          object} @ #{time} but it is already registered with id #{
          future_row['id']} at #{future_row['ends_at']}!" unless future_row.nil?
      end

      ActiveRecord::Base.connection.execute(
        "REPLACE INTO `#{TABLE_NAME}` SET #{column}='#{object.id.to_i
        }', ruleset='#{CONFIG.set_scope}', event=#{event
        }, ends_at='#{time.to_s(:db)}'"
      )
    end
  end
end
