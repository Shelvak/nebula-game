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

    # Link to dispatcher.
    current_actor.link Actor[:dispatcher]
    run!
  end

  def run
    abort "Cannot run pooler while it is running!" if @running
    @running = true

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
    # Disabled until better times until I figure out all those nasty mysql
    # configuration options. Currently server just stalls when
    return

    exclusive do
      with_db_connection do
        Galaxy.all.each do |galaxy|
          LOGGER.block("Ensuring #{galaxy} pool.", component: TAG) do
            SpaceMule.instance.ensure_pool(galaxy)
          end
        end
      end
    end
  end

  def with_db_connection(&block)
    ActiveRecord::Base.connection_pool.with_connection(&block)
  end
end
