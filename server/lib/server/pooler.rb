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
    run!
  end

  def run
    abort "Cannot run pooler while it is running!" if @running
    @running = true

    exclusive do
      with_db_connection do
        loop do
          check_for_pause
          tick
          sleep 10
        end
      end
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
    Galaxy.each do |galaxy|
      debug "Ensuring #{galaxy} pool."
      SpaceMule.instance.ensure_pool(galaxy)
    end
  end

  def with_db_connection(&block)
    ActiveRecord::Base.connection_pool.with_connection(&block)
  end
end
