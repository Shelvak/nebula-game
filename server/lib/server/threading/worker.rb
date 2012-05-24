class Threading::Worker
  include Celluloid
  include NamedLogMessages
  include SeparateConnection

  def initialize(director, name)
    @director = director
    @name = name
    Actor[to_s] = current_actor
  end

  def to_s
    "worker-#{@name}"
  end

  def work(task)
    typesig binding, Threading::Director::Task
    set_ar_connection_id!

    tag = to_s
    exclusive do
      LOGGER.block("Doing work: #{task}.", :component => tag) do
        task.run(tag)
      end
    end

    @director.done!(@name)
  end
end