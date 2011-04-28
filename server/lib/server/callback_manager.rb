class CallbackManager
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
    EVENT_SPAWN => "spawn"
  }

  # Maximum time for callback
  MAX_TIME = 5

  class << self

    def get_class(object)
      object.class.to_s
    end

    # Register _event_ that will happen at _time_ on _object_. It will
    # be scoped in _ruleset_. Beware that ruleset is not considered when
    # updating or checking for object existence.
    def register(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      time ||= object.upgrade_ends_at

      LOGGER.debug("CM: registering event '#{STRING_NAMES[event]
        }' at #{time.to_s(:db)} for #{object}")

      raise ArgumentError.new("object #{object} does not have id!") \
        if object.id.nil?

      ActiveRecord::Base.connection.execute(
        "INSERT INTO callbacks SET class='#{get_class(object)
          }', ruleset='#{CONFIG.set_scope}', object_id=#{object.id}, event=#{
          event}, ends_at='#{time.to_s(:db)}'"
      )
    end

    # Update existing record.
    def update(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      time ||= object.upgrade_ends_at

      LOGGER.debug("CM: updating event '#{STRING_NAMES[event]
        }' at #{time.to_s(:db)} for #{object}")

      ActiveRecord::Base.connection.execute(
        "UPDATE callbacks SET ends_at='#{time.to_s(:db)}' WHERE class='#{
          get_class(object)}' AND object_id=#{object.id} AND event=#{event}"
      )
    end

    def register_or_update(object, event=EVENT_UPGRADE_FINISHED, time=nil)
      if has?(object, event)
        update(object, event, time)
      else
        register(object, event, time)
      end
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

      ActiveRecord::Base.connection.select_value(
        "SELECT COUNT(*) FROM callbacks WHERE class='#{get_class(object)
         }' AND object_id=#{object.id} AND event=#{event} AND #{time_condition}"
      ).to_i > 0
    end

    def unregister(object, event=EVENT_UPGRADE_FINISHED)
      LOGGER.debug("CM: unregistering event '#{STRING_NAMES[event]
        }' for #{object}")

      ActiveRecord::Base.connection.execute(
        "DELETE FROM callbacks WHERE class='#{get_class(object)
          }' AND object_id=#{object.id} AND event=#{event}"
      )
    end

    # Run every callback that should happen by now.
    #
    def tick
      now = Time.now.to_s(:db)

      get_row = lambda do
        LOGGER.suppress(:debug) do
          ActiveRecord::Base.connection.select_one(
            "SELECT class, ruleset, object_id, event FROM callbacks
              WHERE ends_at <= '#{now}' LIMIT 1"
          )
        end
      end

      delete_row = lambda do
        LOGGER.suppress(:debug) do
          ActiveRecord::Base.connection.execute(
            "DELETE FROM callbacks WHERE ends_at <= '#{now}' LIMIT 1"
          )
        end
      end

      # Request unprocessed entries that have hit
      row = get_row.call

      until row.nil?
        begin
          process_callback(row, delete_row)
        rescue Exception => error
          if ENV['environment'] == 'production'
            LOGGER.error(
              "Error in callback manager!\n%s\n\nBacktrace:\n%s" % [
                error.to_s, error.backtrace.join("\n")
              ]
            )
          else
            fail
          end
        end

        row = get_row.call
      end
    end

    private

    def process_callback(row, delete_row)
      title = "Callback for #{row['class']} (evt: '#{
        STRING_NAMES[row['event'].to_i]}', obj id: #{
        row['object_id']}, ruleset: #{row['ruleset']})"
      LOGGER.block(title, :level => :info) do
        time = Benchmark.realtime do
          ActiveRecord::Base.transaction do
            # Delete entry before processing. This is needed because
            # some callbacks may want to add same type callback to same
            # object.
            #
            # We're still protected of callback silently disappearing
            # because this won't be executed if the transaction fails.
            delete_row.call

            begin
              CONFIG.with_set_scope(row['ruleset']) do
                row['class'].constantize.on_callback(
                  row['object_id'].to_i, row['event'].to_i
                )
              end
            rescue ActiveRecord::RecordNotFound
              LOGGER.info(
                "Record was not found. It may have been destroyed."
              )
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
