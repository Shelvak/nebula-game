class CallbackManager
  class UnknownEvent < ArgumentError
    def initialize(klass, id, event)
      super("Unrecognized event #{CallbackManager::STRING_NAMES[event]} (#{
        event} for #{klass} ID #{id}")
    end
  end
  
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
  
  STRING_NAMES = {
    EVENT_UPGRADE_FINISHED => 'upgrade finished',
    EVENT_CONSTRUCTION_FINISHED => 'construction finished',
    EVENT_ENERGY_DIMINISHED => 'energy diminished',
    EVENT_MOVEMENT => 'movement',
    EVENT_DESTROY => 'destroy',
    EVENT_EXPLORATION_COMPLETE => "exploration complete",
    EVENT_COOLDOWN_EXPIRED => "cooldown expired",
    EVENT_RAID => "raid",
    EVENT_CHECK_INACTIVE_PLAYER => "inactivity check",
    EVENT_SPAWN => "spawn",
    EVENT_VIP_TICK => "vip tick",
    EVENT_VIP_STOP => "vip stop",
    EVENT_CREATE_METAL_SYSTEM_OFFER => "create metal system offer",
    EVENT_CREATE_ENERGY_SYSTEM_OFFER => "create energy system offer",
    EVENT_CREATE_ZETIUM_SYSTEM_OFFER => "create zetium system offer",
  }

  # Maximum time for callback
  MAX_TIME = 5
  
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

  class << self
    def get_column(object)
      CLASS_TO_COLUMN.each do |klass, column|
        return column if object.is_a?(klass)
      end

      raise ArgumentError, "Unknown column type for #{object.inspect}!"
    end

    def parse_row(row)
      CLASS_TO_COLUMN.each do |klass, column|
        id = row[column.to_s]
        return [klass, column, id] unless id.nil?
      end

      raise ArgumentError, "Cannot determine class/column/id for #{row.inspect}!"
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

      LOGGER.info("CM: registering event '#{STRING_NAMES[event]
        }' at #{time.to_s(:db)} for #{object}")

      raise ArgumentError.new("object #{object} does not have id!") \
        if object.id.nil?

      column = get_column(object)
      ActiveRecord::Base.connection.execute(
        "INSERT INTO callbacks SET #{column}='#{object.id.to_i
          }', ruleset='#{CONFIG.set_scope}', event=#{event
          }, ends_at='#{time.to_s(:db)}'"
      )
    end

    # Update existing record.
    def update(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      time ||= object.upgrade_ends_at

      LOGGER.info("CM: updating event '#{STRING_NAMES[event]
        }' at #{time.to_s(:db)} for #{object}")

      column = get_column(object)
      ActiveRecord::Base.connection.execute(
        "UPDATE callbacks SET ends_at='#{time.to_s(:db)}' WHERE #{
        column}=#{object.id} AND event=#{event}"
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

      column = get_column(object)
      ! ActiveRecord::Base.connection.select_value(
        "SELECT 1 FROM callbacks WHERE #{column}=#{object.id} AND event=#{event
        } AND #{time_condition} LIMIT 1"
      ).nil?
    end

    def unregister(object, event=EVENT_UPGRADE_FINISHED)
      LOGGER.debug("CM: unregistering event '#{STRING_NAMES[event]
        }' for #{object}")

      column = get_column(object)
      ActiveRecord::Base.connection.execute(
        "DELETE FROM callbacks WHERE #{column}=#{object.id} AND event=#{event}"
      )
    end

    def get(sql)
      ActiveRecord::Base.connection.select_one(
        "SELECT * FROM callbacks #{sql} LIMIT 1"
      )
    end

    # Run every callback that should happen by now.
    #
    def tick(include_failed=false)
      sleep 1 while $IRB_RUNNING

      conn = ActiveRecord::Base.connection

      now = Time.now.to_s(:db)
      conditions = include_failed \
        ? "ends_at <= '#{now}' AND failed <= 1" \
        : "ends_at <= '#{now}' AND failed = 0"
      sql = "WHERE #{conditions} ORDER BY ends_at"

      # Reset failed callbacks to 0 fails so we could try to process them
      # again.
      conn.execute(
        "UPDATE callbacks SET failed=0 WHERE ends_at <= '#{now
          }' AND failed > 1"
      ) if include_failed

      get_row = lambda do
        LOGGER.suppress(:debug) { get(sql) }
      end

      # Request unprocessed entries that have hit
      row = get_row.call

      until row.nil?
        begin
          process_callback(row)
        rescue Exception => error
          if App.in_production?
            LOGGER.error(
              "Error in callback manager!\nRow: %s\n%s" % [
                row.inspect, error.to_log_str
              ]
            )
            LOGGER.info "Marking row as failed."
            conn.execute("UPDATE callbacks SET failed=failed+1 #{sql} LIMIT 1")
          else
            fail
          end
        end

        row = get_row.call
      end
    end

    private

    def process_callback(row)
      klass, column, obj_id = parse_row(row)

      title = "Callback @ #{row['ends_at']} for #{klass.to_s} (evt: '#{
        STRING_NAMES[row['event'].to_i]}', obj id: #{obj_id}, ruleset: #{
        row['ruleset']})"
      LOGGER.block(title, :level => :info) do
        time = Benchmark.realtime do
          ActiveRecord::Base.transaction(:joinable => false) do
            # Delete entry before processing. This is needed because
            # some callbacks may want to add same type callback to same
            # object.
            #
            # We're still protected of callback silently disappearing
            # because this won't be executed if the transaction fails.
            #
            # Use this instead of just using same SQL used for querying, because
            # this is more specific and using same SQL fails when starting
            # server.

            ActiveRecord::Base.connection.execute(
              # Ugly formatting to fit SQL query to one line.
              %Q{DELETE FROM callbacks WHERE ends_at='#{
                row['ends_at'].gsub("'", "")}' AND #{column}=#{obj_id
                } AND event=#{row['event']} LIMIT 1}
            )

            CONFIG.with_set_scope(row['ruleset']) do
              klass.on_callback(obj_id, row['event'].to_i)
            end
          end
        end

        if time > MAX_TIME
          LOGGER.warn("Callback took more than #{MAX_TIME}s (#{time
            })\n\n#{title}")
        end
      end
    end
  end
end
