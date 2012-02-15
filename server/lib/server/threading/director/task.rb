class Threading::Director::Task
  def initialize(description, &block)
    @description = description
    @block = block
  end

  # Runs this task passing it worker name. Checks out DB connection before
  # running it.
  def run(worker_name)
    ActiveRecord::Base.connection_pool.with_connection do
      @block.call(worker_name)
    end
  end

  def to_s
    "<#{self.class.to_s} #{@description}>"
  end
end