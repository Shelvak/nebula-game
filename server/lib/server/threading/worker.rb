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

  def work(ids, klass, method, *args)
    typesig binding, Array, Class, Symbol, Array

    signature = "#{ids.inspect}: #{klass}.#{method}#{args.inspect}"
    info "Doing work for #{signature}."
    klass.send(method, *args)
    info "Work for #{signature} done!"

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