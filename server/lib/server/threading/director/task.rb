class Threading::Director::Task
  def initialize(description, &block)
    @description = description
    @block = block
  end

  # Runs this task passing it worker name.
  def run(worker_name)
    @block.call(worker_name)
  end

  def to_s
    "<#{self.class.to_s} #{@description}>"
  end
end