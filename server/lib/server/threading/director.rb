class Threading::Director
  include NamedLogMessages
  include Celluloid

  def initialize(name, pool)
    @name = name
    Actor[to_s] = current_actor

    @workers = {}
    @free_workers = Java::java.util.LinkedList.new
    @task_queue = Java::java.util.LinkedList.new

    pool.times do |i|
      worker_name = "#{name}_#{i}"
      # If any of the workers die, director should die too or we would have
      # inconsistent state.
      worker = Threading::Worker.new_link(current_actor, worker_name)
      entry = WorkerEntry.new(worker_name, worker)

      @workers[worker_name] = entry
      @free_workers << entry
    end
  end

  def inspect
    "<#{self.class} workers=#{@workers.size}>"
  end

  def to_s
    "director-#{@name}"
  end

  def work(task)
    typesig binding, Threading::Director::Task

    info "Got work: #{task}"
    worker = reserve_worker
    if worker.nil?
      info "No free workers, enqueueing: #{task}"
      @task_queue << task
    else
      worker.work!(task)
    end

    report
  end

  def done(name)
    info "*** #{name} is done working ***"

    entry = @workers[name]

    unless @task_queue.blank?
      task = @task_queue.remove_first
      info "Taking task from queue: #{task}"
      entry.worker.work!(task)
    else
      info "Returning #{name} to pool."
      @free_workers << entry
    end

    report
  end

  def finished?
    @workers.size == @free_workers.size
  end

  private

  def report
    info "free workers: #{@free_workers.size} enqueued tasks: #{
      @task_queue.size}"
  end

  def reserve_worker
    return if @free_workers.blank?
    entry = @free_workers.remove_first
    entry.worker
  end
end