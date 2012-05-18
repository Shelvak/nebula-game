class Pooler
  include Celluloid
  include NamedLogMessages
  include PauseableActor

  TAG = "pooler"

  def to_s
    TAG
  end

  def initialize
    super
    @running = false

    # See "Fibers, Tasks and database connections" in GOTCHAS.md
    @connection, @connection_id =
      ActiveRecord::Base.connection_pool.checkout_with_id

    # Link to dispatcher.
    current_actor.link Actor[:dispatcher]
    run!
  end

  def finalize
    ActiveRecord::Base.connection_pool.checkin(@connection)
  end

  def run
    abort RuntimeError.new("Cannot run pooler while it is running!") if @running
    @running = true

    ActiveRecord::Base.connection_id = @connection_id

    loop do
      check_for_pause
      tick
      sleep 10
    end
  end

  def pause
    info "Pausing."
    super
  end

  def resume
    info "Resuming."
    super
  end

private

  def tick
    exclusive do
      Galaxy.all.each do |galaxy|
        LOGGER.block("Ensuring #{galaxy} pool.", component: TAG) do
          SpaceMule.instance.ensure_pool(galaxy)
        end
      end
    end
  end
end
