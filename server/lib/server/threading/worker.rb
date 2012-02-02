class Threading::Worker
  include Celluloid
  include Log

  def initialize(director, syncer, name)
    @director = director
    @syncer = syncer
    @name = name
  end

  def work(player_ids, message)
    log "--- starting work (#{player_ids.inspect}) for #{message} seconds ---"
    Kernel.sleep message
    log "--- done working (#{player_ids.inspect}) for #{message} seconds ---"

    @director.done!(@name, player_ids)
  end

  # Emit a sync with _token_.
  def sync(token)
    @syncer.sync!(@name, token)
  end

  # Block until syncer gets _count_ sync emits for _token_.
  def request_sync(token, count)
    exclusive do
      @syncer.request_sync(@name, count, token)
    end
  end
end