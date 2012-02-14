class Threading::Worker
  include Celluloid
  include NamedLogMessages

  def initialize(director, syncer, name)
    @director = director
    @syncer = syncer
    @name = name
  end

  def to_s
    "worker-#{@name}"
  end

  def work(ids, task)
    typesig binding, Array, Threading::Director::Task

    tag = to_s
    exclusive do
      LOGGER.block(
        "Doing work for #{ids.inspect}: #{task}.", :component => tag
      ) do
        task.run(tag)
      end
    end

    @director.done!(@name, ids)
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