class Threading::Worker
  include Celluloid
  include NamedLogMessages

  def initialize(director, name)
    @director = director
    @name = name
    Actor[to_s] = current_actor

    # See "Fibers, Tasks and database connections" in GOTCHAS.md
    @connection, @connection_id =
      ActiveRecord::Base.connection_pool.checkout_with_id
  end

  def finalize
    ActiveRecord::Base.connection_pool.checkin(@connection)
  end

  def to_s
    "worker-#{@name}"
  end

  def work(task)
    typesig binding, Threading::Director::Task

    ActiveRecord::Base.connection_id = @connection_id

    tag = to_s
    exclusive do
      LOGGER.block("Doing work: #{task}.", :component => tag) do
        task.run(tag)
      end
    end

    @director.done!(@name)
  end
end