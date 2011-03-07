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

  STRING_NAMES = {
    EVENT_UPGRADE_FINISHED => 'upgrade finished',
    EVENT_CONSTRUCTION_FINISHED => 'construction finished',
    EVENT_ENERGY_DIMINISHED => 'energy diminished',
    EVENT_MOVEMENT => 'movement',
    EVENT_DESTROY => 'destroy',
    EVENT_EXPLORATION_COMPLETE => "exploration complete",
    EVENT_COOLDOWN_EXPIRED => "cooldown expired",
    EVENT_RAID => "raid",
  }

  # Maximum time for callback
  MAX_TIME = 2

  def self.get_class(object)
    object.class.to_s
  end

  # Register _event_ that will happen at _time_ on _object_. It will
  # be scoped in _ruleset_. Beware that ruleset is not considered when
  # updating or checking for object existence.
  def self.register(object, event=EVENT_UPGRADE_FINISHED, time=nil)
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
  def self.update(object, event=EVENT_UPGRADE_FINISHED, time=nil)
    time ||= object.upgrade_ends_at

    LOGGER.debug("CM: updating event '#{STRING_NAMES[event]
      }' at #{time.to_s(:db)} for #{object}")

    ActiveRecord::Base.connection.execute(
      "UPDATE callbacks SET ends_at='#{time.to_s(:db)}' WHERE class='#{
        get_class(object)}' AND object_id=#{object.id} AND event=#{event}"
    )
  end

  def self.has?(object, event, time)
    time_condition = time.is_a?(Range) \
      ? "(ends_at BETWEEN '#{time.first.to_s(:db)}' AND '#{
        time.last.to_s(:db)}')" \
      : "ends_at='#{time.to_s(:db)}'"

    ActiveRecord::Base.connection.select_value(
      "SELECT COUNT(*) FROM callbacks WHERE class='#{get_class(object)
       }' AND object_id=#{object.id} AND event=#{event} AND #{time_condition}"
    ).to_i > 0
  end

  def self.unregister(object, event=EVENT_UPGRADE_FINISHED)
    LOGGER.debug("CM: unregistering event '#{STRING_NAMES[event]
      }' for #{object}")

    ActiveRecord::Base.connection.execute(
      "DELETE FROM callbacks WHERE class='#{get_class(object)
        }' AND object_id=#{object.id} AND event=#{event}"
    )
  end

  # Run every callback that should happen by now.
  #
  # Returns time for
  def self.tick
    now = Time.now.to_s(:db)

    # Request unprocessed entries that have hit
    rows = nil
    LOGGER.suppress(:debug) do
      rows = ActiveRecord::Base.connection.select_all(
        "SELECT class, ruleset, object_id, event FROM callbacks
          WHERE ends_at <= '#{now}'"
      )
    end

    unless rows.blank?
      # Delete processed entries (before actions are ran, to ensure that
      # new callbacks can be added properly).
      LOGGER.suppress(:debug) do
        ActiveRecord::Base.connection.execute(
          "DELETE FROM callbacks WHERE ends_at <= '#{now}'"
        )
      end

      rows.each do |row|
        begin
          title = "Callback for #{row['class']} (evt: '#{
            STRING_NAMES[row['event'].to_i]}', obj id: #{
            row['object_id']}, ruleset: #{row['ruleset']})"
          LOGGER.block(title, :level => :info) do
            time = Benchmark.realtime do
              ActiveRecord::Base.transaction do
                begin
                  CONFIG.with_set_scope(row['ruleset']) do
                    row['class'].constantize.on_callback(
                      row['object_id'].to_i,
                      row['event'].to_i
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
      end
    end
  end
end
