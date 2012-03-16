class Threading::Worker
  include Celluloid
  include NamedLogMessages

  def initialize(director, name)
    @director = director
    @name = name
  end

  def to_s
    "worker-#{@name}"
  end

  def work(task)
    typesig binding, Threading::Director::Task

    tag = to_s
    exclusive do
      LOGGER.block("Doing work: #{task}.", :component => tag) do
        task.run(tag)
      end
    end

    @director.done!(@name)
  end
end